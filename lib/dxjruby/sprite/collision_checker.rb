module DXJRuby
  class Sprite
    module CollisionChecker
      Ellipse = Struct.new(:fRad_X, :fRad_Y, :fAngle, :fCx, :fCy)

      def self._intersect(x1, y1, x2, y2, x3, y3, x4, y4)
        ((x1 - x2) * (y3 - y1) + (y1 - y2) * (x1 - x3)) *
          ((x1 - x2) * (y4 - y1) + (y1 - y2) * (x1 - x4))
      end

      def self._check_line_line(x1, y1, x2, y2, x3, y3, x4, y4)
        !(
          (((x1 - x2) * (y3 - y1) + (y1 - y2) * (x1 - x3)) *
           ((x1 - x2) * (y4 - y1) + (y1 - y2) * (x1 - x4)) > 0.0) ||
          (((x3 - x4) * (y1 - y3) + (y3 - y4) * (x3 - x1)) *
           ((x3 - x4) * (y2 - y3) + (y3 - y4) * (x3 - x2)) > 0.0 )
        )
      end

      def self._check_circle_line(x, y, r, x1, y1, x2, y2)
        vx = x2-x1
        vy = y2-y1
        cx = x-x1
        cy = y-y1

        if vx == 0 && vy == 0
          return CCk.check_point_circle(x, y, r, x1, y1)
        end

        n1 = vx * cx + vy * cy
        if n1 < 0
          return cx*cx + cy*cy < r * r
        end

        n2 = vx * vx + vy * vy
        if n1 > n2
          len = (x2 - x)*(x2 - x) + (y2 - y)*(y2 - y)
          return len < r * r
        else
          n3 = cx * cx + cy * cy
          return n3-(n1.to_f/n2)*n1 < r * r
        end
      end

      def self.check_point_circle(px, py, cx, cy, cr)
        (cr*cr) >= ((cx-px) * (cx-px) + (cy-py) * (cy-py))
      end

      def self.check_point_straight_rect(x, y, x1, y1, x2, y2)
        ((x) >= (x1) &&
         (y) >= (y1) &&
         (x) < (x2) &&
         (y) < (y2))
      end

      def self.check_point_triangle(x, y, x1, y1, x2, y2, x3, y3)
        if ((x1 - x3) * (y1 - y2) == (x1 - x2) * (y1 - y3))
          return false
        end

        cx = (x1 + x2 + x3).to_f / 3
        cy = (y1 + y2 + y3).to_f / 3

        if (_intersect( x1, y1, x2, y2, x, y, cx, cy ) < 0.0 ||
            _intersect( x2, y2, x3, y3, x, y, cx, cy ) < 0.0 ||
            _intersect( x3, y3, x1, y1, x, y, cx, cy ) < 0.0 )
          return false
        end

        return true
      end

      def self.check_circle_circle(ox, oy, _or, dx, dy, dr)
        ((_or+dr) * (_or+dr) >= (ox-dx) * (ox-dx) + (oy-dy) * (oy-dy))
      end

      def self.check_ellipse_ellipse(_E1, _E2)
        _DefAng = _E1.fAngle-_E2.fAngle
        _Cos = Math.cos( _DefAng )
        _Sin = Math.sin( _DefAng )
        nx =  _E2.fRad_X * _Cos
        ny = -_E2.fRad_X * _Sin
        px =  _E2.fRad_Y * _Sin
        py =  _E2.fRad_Y * _Cos
        ox =  Math.cos( _E1.fAngle )*(_E2.fCx-_E1.fCx) + Math.sin(_E1.fAngle)*(_E2.fCy-_E1.fCy)
        oy = -Math.sin( _E1.fAngle )*(_E2.fCx-_E1.fCx) + Math.cos(_E1.fAngle)*(_E2.fCy-_E1.fCy)

        rx_pow2 = 1.0/(_E1.fRad_X*_E1.fRad_X)
        ry_pow2 = 1.0/(_E1.fRad_Y*_E1.fRad_Y)
        _A = rx_pow2*nx*nx + ry_pow2*ny*ny
        _B = rx_pow2*px*px + ry_pow2*py*py
        _D = 2*rx_pow2*nx*px + 2*ry_pow2*ny*py
        _E = 2*rx_pow2*nx*ox + 2*ry_pow2*ny*oy
        _F = 2*rx_pow2*px*ox + 2*ry_pow2*py*oy
        _G = (ox.to_f/_E1.fRad_X)*(ox.to_f/_E1.fRad_X) + (oy.to_f/_E1.fRad_Y)*(oy.to_f/_E1.fRad_Y) - 1

        tmp1 = 1.0/(_D*_D-4*_A*_B)
        h = (_F*_D-2*_E*_B)*tmp1
        k = (_E*_D-2*_A*_F)*tmp1
        _Th = (_B-_A)==0 ? 0 : Math.atan( _D.to_f/(_B-_A) ) * 0.5

        _CosTh = Math.cos(_Th)
        _SinTh = Math.sin(_Th)
        _A_tt = _A*_CosTh*_CosTh + _B*_SinTh*_SinTh - _D*_CosTh*_SinTh
        _B_tt = _A*_SinTh*_SinTh + _B*_CosTh*_CosTh + _D*_CosTh*_SinTh
        _KK = _A*h*h + _B*k*k + _D*h*k - _E*h - _F*k + _G > 0 ? 0 : _A*h*h + _B*k*k + _D*h*k - _E*h - _F*k + _G
        _Rx_tt = 1+Math.sqrt(-_KK.to_f/_A_tt)
        _Ry_tt = 1+Math.sqrt(-_KK.to_f/_B_tt)
        x_tt = _CosTh*h-_SinTh*k
        y_tt = _SinTh*h+_CosTh*k
        _JudgeValue = x_tt*x_tt.to_f/(_Rx_tt*_Rx_tt) + y_tt*y_tt.to_f/(_Ry_tt*_Ry_tt)

        return _JudgeValue <= 1
      end

      def self.check_circle_tilted_rect(cx, cy, cr, x1, y1, x2, y2, x3, y3, x4, y4)
        CollisionChecker.check_point_triangle(cx, cy, x1, y1, x2, y2, x3, y3) ||
          CollisionChecker.check_point_triangle(cx, cy, x1, y1, x3, y3, x4, y4) ||
          _check_circle_line(cx, cy, cr, x1, y1, x2, y2) ||
          _check_circle_line(cx, cy, cr, x2, y2, x3, y3) ||
          _check_circle_line(cx, cy, cr, x3, y3, x4, y4) ||
          _check_circle_line(cx, cy, cr, x4, y4, x1, y1)
      end

      def self.check_circle_triangle(cx, cy, cr, x1, y1, x2, y2, x3, y3)
        CollisionChecker.check_point_triangle(cx, cy, x1, y1, x2, y2, x3, y3) ||
          _check_circle_line(cx, cy, cr, x1, y1, x2, y2) ||
          _check_circle_line(cx, cy, cr, x2, y2, x3, y3) ||
          _check_circle_line(cx, cy, cr, x3, y3, x1, y1)
      end

      def self.check_rect_rect(ax1, ay1, ax2, ay2, bx1, by1, bx2, by2)
        ax1 < bx2 &&
          ay1 < by2 &&
          bx1 < ax2 &&
          by1 < ay2
      end

      # Rect(may be tilted) vs Triangle
      def self.check_tilted_rect_triangle(ox1, oy1, ox2, oy2, ox3, oy3, ox4, oy4,
                                          dx1, dy1, dx2, dy2, dx3, dy3)
        _check_line_line(ox1, oy1, ox2, oy2, dx1, dy1, dx2, dy2) ||
          _check_line_line(ox1, oy1, ox2, oy2, dx2, dy2, dx3, dy3) ||
          _check_line_line(ox1, oy1, ox2, oy2, dx3, dy3, dx1, dy1) ||
          _check_line_line(ox2, oy2, ox3, oy3, dx1, dy1, dx2, dy2) ||
          _check_line_line(ox2, oy2, ox3, oy3, dx2, dy2, dx3, dy3) ||
          _check_line_line(ox2, oy2, ox3, oy3, dx3, dy3, dx1, dy1) ||
          _check_line_line(ox3, oy3, ox4, oy4, dx1, dy1, dx2, dy2) ||
          _check_line_line(ox3, oy3, ox4, oy4, dx2, dy2, dx3, dy3) ||
          _check_line_line(ox3, oy3, ox4, oy4, dx3, dy3, dx1, dy1) ||
          _check_line_line(ox4, oy4, ox1, oy1, dx1, dy1, dx2, dy2) ||
          _check_line_line(ox4, oy4, ox1, oy1, dx2, dy2, dx3, dy3) ||
          _check_line_line(ox4, oy4, ox1, oy1, dx3, dy3, dx1, dy1) ||
          CollisionChecker.check_point_triangle(dx1, dy1, ox1, oy1, ox2, oy2, ox3, oy3) ||
          CollisionChecker.check_point_triangle(dx1, dy1, ox1, oy1, ox3, oy3, ox4, oy4) ||
          CollisionChecker.check_point_triangle(ox1, oy1, dx1, dy1, dx2, dy2, dx3, dy3)
      end

      # Triangle vs Triangle
      def self.check_triangle_triangle(ox1, oy1, ox2, oy2, ox3, oy3,
                                       dx1, dy1, dx2, dy2, dx3, dy3)
        _check_line_line(ox1, oy1, ox2, oy2, dx2, dy2, dx3, dy3) ||
          _check_line_line(ox1, oy1, ox2, oy2, dx3, dy3, dx1, dy1) ||
          _check_line_line(ox2, oy2, ox3, oy3, dx1, dy1, dx2, dy2) ||
          _check_line_line(ox2, oy2, ox3, oy3, dx3, dy3, dx1, dy1) ||
          _check_line_line(ox3, oy3, ox1, oy1, dx1, dy1, dx2, dy2) ||
          _check_line_line(ox3, oy3, ox1, oy1, dx2, dy2, dx3, dy3) ||
          CollisionChecker.check_point_triangle(ox1, oy1, dx1, dy1, dx2, dy2, dx3, dy3) ||
          CollisionChecker.check_point_triangle(dx1, dy1, ox1, oy1, ox2, oy2, ox3, oy3)
      end
    end
  end
end
