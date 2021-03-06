//
//  JD3DPoint.m
//  YoungTag
//
//  Created by 宋庆功 on 2018/11/7.
//  Copyright © 2018年 Young. All rights reserved.
//

#import "JD3DPoint.h"

@implementation JD3DPoint

struct JDMatrix {
    NSInteger column;
    NSInteger row;
    CGFloat matrix[4][4];
};

typedef struct JDMatrix JDMatrix;

static JDMatrix JDMatrixMake(NSInteger column, NSInteger row) {
    JDMatrix matrix;
    matrix.column = column;
    matrix.row = row;
    for(NSInteger i = 0; i < column; i++){
        for(NSInteger j = 0; j < row; j++){
            matrix.matrix[i][j] = 0;
        }
    }
    
    return matrix;
}

static JDMatrix JDMatrixMakeFromArray(NSInteger column, NSInteger row, CGFloat *data) {
    JDMatrix matrix = JDMatrixMake(column, row);
    for (int i = 0; i < column; i ++) {
        CGFloat *t = data + (i * row);
        for (int j = 0; j < row; j++) {
            matrix.matrix[i][j] = *(t + j);
        }
    }
    return matrix;
}

static JDMatrix JDMatrixMutiply(JDMatrix a, JDMatrix b) {
    JDMatrix result = JDMatrixMake(a.column, b.row);
    for(NSInteger i = 0; i < a.column; i ++){
        for(NSInteger j = 0; j < b.row; j ++){
            for(NSInteger k = 0; k < a.row; k++){
                result.matrix[i][j] += a.matrix[i][k] * b.matrix[k][j];
            }
        }
    }
    return result;
}

- (JD3DPoint *)makeRotationWithDirection:(JD3DPoint *)direction angle:(CGFloat)angle
{
    if (angle == 0) {
        return self;
    }
    
    CGFloat temp2[1][4] = {self.x, self.y, self.z, 1};
    
    JDMatrix result = JDMatrixMakeFromArray(1, 4, *temp2);
    
    if (direction.z * direction.z + direction.y * direction.y != 0) {
        CGFloat cos1 = direction.z / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat sin1 = direction.y / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat t1[4][4] = {{1, 0, 0, 0}, {0, cos1, sin1, 0}, {0, -sin1, cos1, 0}, {0, 0, 0, 1}};
        JDMatrix m1 = JDMatrixMakeFromArray(4, 4, *t1);
        result = JDMatrixMutiply(result, m1);
    }
    
    if (direction.x * direction.x + direction.y * direction.y + direction.z * direction.z != 0) {
        CGFloat cos2 = sqrt(direction.y * direction.y + direction.z * direction.z) / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat sin2 = -direction.x / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat t2[4][4] = {{cos2, 0, -sin2, 0}, {0, 1, 0, 0}, {sin2, 0, cos2, 0}, {0, 0, 0, 1}};
        JDMatrix m2 = JDMatrixMakeFromArray(4, 4, *t2);
        result = JDMatrixMutiply(result, m2);
    }
    
    CGFloat cos3 = cos(angle);
    CGFloat sin3 = sin(angle);
    CGFloat t3[4][4] = {{cos3, sin3, 0, 0}, {-sin3, cos3, 0, 0}, {0, 0, 1, 0}, {0, 0, 0, 1}};
    JDMatrix m3 = JDMatrixMakeFromArray(4, 4, *t3);
    result = JDMatrixMutiply(result, m3);
    
    if (direction.x * direction.x + direction.y * direction.y + direction.z * direction.z != 0) {
        CGFloat cos2 = sqrt(direction.y * direction.y + direction.z * direction.z) / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat sin2 = -direction.x / sqrt(direction.x * direction.x + direction.y * direction.y + direction.z * direction.z);
        CGFloat t2_[4][4] = {{cos2, 0, sin2, 0}, {0, 1, 0, 0}, {-sin2, 0, cos2, 0}, {0, 0, 0, 1}};
        JDMatrix m2_ = JDMatrixMakeFromArray(4, 4, *t2_);
        result = JDMatrixMutiply(result, m2_);
    }
    
    if (direction.z * direction.z + direction.y * direction.y != 0) {
        CGFloat cos1 = direction.z / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat sin1 = direction.y / sqrt(direction.z * direction.z + direction.y * direction.y);
        CGFloat t1_[4][4] = {{1, 0, 0, 0}, {0, cos1, -sin1, 0}, {0, sin1, cos1, 0}, {0, 0, 0, 1}};
        JDMatrix m1_ = JDMatrixMakeFromArray(4, 4, *t1_);
        result = JDMatrixMutiply(result, m1_);
    }
    
    JD3DPoint *resultPoint = [[JD3DPoint alloc] init];
    resultPoint.x = result.matrix[0][0];
    resultPoint.y = result.matrix[0][1];
    resultPoint.z = result.matrix[0][2];
    return resultPoint;
}

@end
