package ru.vsu.cs.MeAndFlora.MainServer.config.component;

import java.util.ArrayList;
import java.util.List;

import org.locationtech.jts.geom.Coordinate;
import org.locationtech.jts.geom.Point;
import org.springframework.stereotype.Component;

import lombok.RequiredArgsConstructor;
import ru.vsu.cs.MeAndFlora.MainServer.controller.dto.GeoJsonPointDto;
import ru.vsu.cs.MeAndFlora.MainServer.service.impl.FloraServiceImpl;

@Component
@RequiredArgsConstructor
public class JsonUtil {

    public Point jsonToPoint(GeoJsonPointDto geoDto) {
        return FloraServiceImpl.geometryFactory.createPoint(new Coordinate(

                        geoDto.getCoordinates().get(0),
                        geoDto.getCoordinates().get(1)

                )
        );
    }

    public GeoJsonPointDto pointToJson(Point point) {
        List<Double> returnList = new ArrayList<>();

        returnList.add(point.getX());
        returnList.add(point.getY());

        return new GeoJsonPointDto("point", returnList);
    }

}
