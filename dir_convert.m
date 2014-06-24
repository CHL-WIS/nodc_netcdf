function ang=dir_convert(angle,adjust)


if adjust == 270
    ang = 270. -  angle;
elseif adjust == 180
    ang = angle - 180;
end

ang(ang < 0) = ang(ang < 0) + 360;