package com.jupddang.jupddang.plogging.test;

import com.uber.h3core.H3Core;
import java.util.List;

public class H3Test {

    // Test Coordinate Object (Java 16+ Record)
    record Coordinate(double lat, double lng) {}

    public static void main(String[] args) {
        try {
            // 1. Initialize H3 Library
            H3Core h3 = H3Core.newInstance();
            System.out.println("✅ H3Core initialized successfully");

            // 2. Set Resolution (9: Street/Building level, 7: Neighborhood level)
            int resolution = 9;

            // 3. Prepare Test Data (Near Seoul City Hall -> Slightly further away)
            // Assume this is List<Coordinate> received from Frontend
            Coordinate startPoint = new Coordinate(37.5665, 126.9780);
            Coordinate endPoint = new Coordinate(37.5675, 126.9800);

            System.out.println(String.format("🚩 Start Point: %f, %f", startPoint.lat, startPoint.lng));
            System.out.println(String.format("🏁 End Point:   %f, %f", endPoint.lat, endPoint.lng));

            // 4. Convert Coordinate -> H3 Index (Hexagon ID)
            // Note: H3 uses (lat, lng) order.
            long startCell = h3.latLngToCell(startPoint.lat, startPoint.lng, resolution);
            long endCell = h3.latLngToCell(endPoint.lat, endPoint.lng, resolution);

            System.out.println("--------------------------------------------------");
            System.out.println("Start Cell ID (Long):   " + startCell);
            System.out.println("Start Cell ID (String): " + h3.h3ToString(startCell));
            System.out.println("--------------------------------------------------");

            // 5. [Core] Get Path Cells (Line Interpolation)
            // Finds the stepping-stone hexagons connecting the start and end points.
            List<Long> pathCells = h3.gridPathCells(startCell, endCell);

            System.out.println("🚀 Path Analysis Result (Captured Hexagons)");
            int count = 1;
            for (Long cellId : pathCells) {
                String hexAddr = h3.h3ToString(cellId);
                System.out.println(count++ + ". " + hexAddr + " (Cell ID: " + cellId + ")");
            }

            System.out.println("--------------------------------------------------");
            System.out.println("Total Captured Grids: " + pathCells.size());

        } catch (Exception e) {
            e.printStackTrace();
            System.out.println("❌ Error: " + e.getMessage());
        }
    }
}