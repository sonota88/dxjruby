require_relative "helper"

require "dxjruby/sprite/collision_checker"

class TestCollisionChecker < Minitest::Test
  Ellipse = DXJRuby::Sprite::CollisionChecker::Ellipse # alias

  def sut
    DXJRuby::Sprite::CollisionChecker
  end

  def to_radian(angle)
    angle.to_f * Math::PI / 180
  end

  # line / line

  def test_check_line_line__collided
    collided = sut._check_line_line(
      0, 10, 10, 0,
      0, 0, 5 + 1, 5 + 1
    )

    assert_equal(true, collided)
  end

  def test_check_line_line__not_collided
    collided = sut._check_line_line(
      0, 10, 10, 0,
      0, 0, 5 - 1, 5 - 1
    )

    assert_equal(false, collided)
  end

  # circle / line

  def test_check_circle_line__collided
    collided = sut._check_circle_line(
      0, 0, 10,
      0, 0, 10, 10
    )

    assert_equal(true, collided)
  end

  def test_check_circle_line__not_collided
    collided = sut._check_circle_line(
      0, 0, 10,
      0, 0 + 11, 10, 10 + 11
    )

    assert_equal(false, collided)
  end

  # point / circle

  def test_check_point_circle__collided
    collided = sut.check_point_circle(
      0, 0,
      0, 0, 10,
    )

    assert_equal(true, collided)
  end

  def test_check_point_circle__not_collided
    collided = sut.check_point_circle(
      0, 11,
      0, 0, 10,
    )

    assert_equal(false, collided)
  end

  # point / straight_rect

  def test_check_point_straight_rect__collided
    collided = sut.check_point_straight_rect(
      5, 5,
      0, 0, 10, 10
    )

    assert_equal(true, collided)
  end

  def test_check_point_straight_rect__not_collided
    collided = sut.check_point_straight_rect(
      5, 11,
      0, 0, 10, 10
    )

    assert_equal(false, collided)
  end

  # point / triangle

  def test_check_point_triangle__collided
    collided = sut.check_point_triangle(
      10, 1,
      0, 0,
      20, 0,
      10, 10
    )

    assert_equal(true, collided)
  end

  def test_check_point_triangle__not_collided
    collided = sut.check_point_triangle(
      10, -1,
      0, 0,
      20, 0,
      10, 10
    )

    assert_equal(false, collided)
  end

  # circle / circle

  def test_check_circle_circle__collided
    collided = sut.check_circle_circle(
      0, 0, 10,
      0 + 1, 0, 10
    )

    assert_equal(true, collided)
  end

  def test_check_circle_circle__not_collided
    collided = sut.check_circle_circle(
      0, 0, 10,
      0 + 30, 0, 10
    )

    assert_equal(false, collided)
  end

  # ellipse / ellipse

  def test_check_ellipse_ellipse__collided
    e1 = Ellipse.new(
      fCx: 0, fCy: 0,
      fRad_X: 20, fRad_Y: 10,
      fAngle: to_radian(1)
    )
    e2 = Ellipse.new(
      fCx: 1, fCy: 0,
      fRad_X: 20, fRad_Y: 10,
      fAngle: to_radian(1)
    )

    collided = sut.check_ellipse_ellipse(e1, e2)

    assert_equal(true, collided)
  end

  def test_check_ellipse_ellipse__not_collided
    e1 = Ellipse.new(
      fCx: 0, fCy: 0,
      fRad_X: 20, fRad_Y: 10,
      fAngle: to_radian(1)
    )
    e2 = Ellipse.new(
      fCx: 1 + 40, fCy: 0,
      fRad_X: 20, fRad_Y: 10,
      fAngle: to_radian(1)
    )

    collided = sut.check_ellipse_ellipse(e1, e2)

    assert_equal(false, collided)
  end

  # circle / tilted_rect

  def test_check_circle_tilted_rect__collided
    rect_poss = [
      [10, 20],
      [20, 10],
      [10,  0],
      [ 0, 10],
    ]

    collided = sut.check_circle_tilted_rect(
      10, 10, 10,
      *rect_poss.flatten
    )

    assert_equal(true, collided)
  end

  def test_check_circle_tilted_rect__not_collided
    rect_points = [
      [10, 20],
      [20, 10],
      [10,  0],
      [ 0, 10],
    ]

    collided = sut.check_circle_tilted_rect(
      10 + 30, 10, 10,
      *rect_points.flatten
    )

    assert_equal(false, collided)
  end

  # circle / triangle

  def test_check_circle_triangle__collided
    collided = sut.check_circle_triangle(
      0, 0, 10,
      0, 0,
      10, 10,
      20, 0
    )

    assert_equal(true, collided)
  end

  def test_check_circle_triangle__not_collided
    collided = sut.check_circle_triangle(
      40, 0, 10,
      0, 0,
      10, 10,
      20, 0
    )

    assert_equal(false, collided)
  end

  # rect / rect

  def test_check_rect_rect__collided
    collided = sut.check_rect_rect(
      0, 0, 20, 20,
      10, 0, 30, 20,
    )

    assert_equal(true, collided)
  end

  def test_check_rect_rect__not_collided
    collided = sut.check_rect_rect(
      0, 0, 20, 20,
      10 + 20, 0, 30 + 20, 20,
    )

    assert_equal(false, collided)
  end

  # tilted_rect / triangle

  def test_check_tilted_rect_triangle__collided
    rect_points = [
      10, 20,
      20, 10,
      10,  0,
       0, 10,
    ]
    triangle_points = [
       0,  0,
      10, 20,
      20,  0,
    ]

    collided = sut.check_tilted_rect_triangle(
      *rect_points,
      *triangle_points
    )

    assert_equal(true, collided)
  end

  def test_check_tilted_rect_triangle__not_collided
    rect_points = [
      10, 20,
      20, 10,
      10,  0,
       0, 10,
    ]
    triangle_points = [
      20 +  0,  0,
      20 + 10, 20,
      20 + 20,  0,
    ]

    collided = sut.check_tilted_rect_triangle(
      *rect_points,
      *triangle_points
    )

    assert_equal(false, collided)
  end

  # triangle / triangle

  def test_check_triangle_triangle__collided
    triangle_points1 = [
       0,  0,
      10, 10,
      20,  0,
    ]
    triangle_points2 = [
       0 + 1,  0,
      10 + 1, 10,
      20 + 1,  0,
    ]

    collided = sut.check_triangle_triangle(
      *triangle_points1,
      *triangle_points2
    )

    assert_equal(true, collided)
  end

  def test_check_triangle_triangle__not_collided
    triangle_points1 = [
       0,  0,
      10, 10,
      20,  0,
    ]
    triangle_points2 = [
       0 + 30,  0,
      10 + 30, 10,
      20 + 30,  0,
    ]

    collided = sut.check_triangle_triangle(
      *triangle_points1,
      *triangle_points2
    )

    assert_equal(false, collided)
  end
end
