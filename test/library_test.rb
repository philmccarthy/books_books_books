require 'minitest/autorun'
require 'minitest/pride'
require './lib/library'
require './lib/author'
require './lib/book'

class LibraryTest < Minitest::Test

  def setup
    @dpl = Library.new("Denver Public Library")
    @charlotte_bronte = Author.new({first_name: "Charlotte", last_name: "Bronte"})
    @jane_eyre = @charlotte_bronte.write("Jane Eyre", "October 16, 1847")
    @professor = @charlotte_bronte.write("The Professor", "1857")
    @villette = @charlotte_bronte.write("Villette", "1853")
    @harper_lee = Author.new({first_name: "Harper", last_name: "Lee"})
    @mockingbird = @harper_lee.write("To Kill a Mockingbird", "July 11, 1960")
  end

  def test_it_exists_and_has_attributes
    assert_instance_of Library, @dpl
    assert_equal "Denver Public Library", @dpl.name
    assert_equal [], @dpl.books
    assert_equal [], @dpl.authors
  end

  def test_it_can_add_books
    @dpl.add_author(@charlotte_bronte)
    @dpl.add_author(@harper_lee)
    assert_equal [@charlotte_bronte, @harper_lee], @dpl.authors
    assert_equal [@jane_eyre, @professor, @villette, @mockingbird], @dpl.books
  end

  def test_it_can_return_publication_time_frame_for_author
    expected = {:start=>"1847", :end=>"1857"}
    assert_equal expected, @dpl.publication_time_frame_for(@charlotte_bronte)
    expected = {:start=>"1960", :end=>"1960"}
    assert_equal expected, @dpl.publication_time_frame_for(@harper_lee)
  end

  def test_it_can_run_checkoutable_check
    @dpl.add_author(@charlotte_bronte)
    @dpl.add_author(@harper_lee)
    assert @dpl.checkoutable?(@jane_eyre)
  end

  def test_it_can_checkout_books
    assert_equal false, @dpl.checkout(@mockingbird)
    assert_equal false, @dpl.checkout(@jane_eyre)
    @dpl.add_author(@charlotte_bronte)
    @dpl.add_author(@harper_lee)
    assert @dpl.checkout(@jane_eyre)
    assert_equal [@jane_eyre], @dpl.checked_out_books
    assert_equal false, @dpl.checkout(@jane_eyre)
  end

  def test_it_can_return_books
    @dpl.add_author(@charlotte_bronte)
    @dpl.add_author(@harper_lee)
    @dpl.checkout(@jane_eyre)
    @dpl.return(@jane_eyre)
    assert_equal [], @dpl.checked_out_books
    @dpl.checkout(@jane_eyre)
    @dpl.checkout(@villette)
    assert_equal [@jane_eyre, @villette], @dpl.checked_out_books
  end

  def test_it_can_find_most_popular_book
    @dpl.add_author(@charlotte_bronte)
    @dpl.add_author(@harper_lee)
    @dpl.checkout(@jane_eyre)
    @dpl.return(@jane_eyre)
    @dpl.checkout(@jane_eyre)
    @dpl.checkout(@villette)
    @dpl.checkout(@mockingbird)
    @dpl.return(@mockingbird)
    @dpl.checkout(@mockingbird)
    @dpl.return(@mockingbird)
    @dpl.checkout(@mockingbird)
    assert_equal @mockingbird, @dpl.most_popular_book
  end

  def test_popularity_hash_counts_checkouts
    @dpl.add_author(@charlotte_bronte)
    @dpl.add_author(@harper_lee)
    @dpl.checkout(@jane_eyre)
    @dpl.return(@jane_eyre)
    @dpl.checkout(@jane_eyre)
    @dpl.checkout(@villette)
    @dpl.checkout(@mockingbird)
    @dpl.return(@mockingbird)
    @dpl.checkout(@mockingbird)
    @dpl.return(@mockingbird)
    @dpl.checkout(@mockingbird)
    expected = {@jane_eyre => 2, @villette => 1, @mockingbird => 3}
    assert_equal expected, @dpl.popularity
  end

end
