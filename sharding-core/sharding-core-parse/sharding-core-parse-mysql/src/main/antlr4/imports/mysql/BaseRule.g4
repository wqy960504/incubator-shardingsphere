/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

grammar BaseRule;

import Symbol, Keyword, Literals;

parameterMarker
    : QUESTION_
    ;

number
   : NUMBER_
   ;

string
    : STRING_
    ;

literals_
    : BIT_NUM_ | NUMBER_ | HEX_DIGIT_ | STRING_
    ;

identifier_
    : IDENTIFIER_ | unreservedWord_
    ;

variable_
    : (AT_ AT_)? (GLOBAL | PERSIST | PERSIST_ONLY | SESSION)? DOT_? identifier_
    ;

unreservedWord_
    : ACCOUNT | ACTION | AFTER | ALGORITHM | ALWAYS | ANY | AUTO_INCREMENT 
    | AVG_ROW_LENGTH | BEGIN | BTREE | CHAIN | CHARSET | CHECKSUM | CIPHER 
    | CLIENT | COALESCE | COLUMNS | COLUMN_FORMAT | COMMENT | COMMIT | COMMITTED 
    | COMPACT | COMPRESSED | COMPRESSION | CONNECTION | CONSISTENT | CURRENT | DATA 
    | DATE | DELAY_KEY_WRITE | DISABLE | DISCARD | DISK | DUPLICATE | ENABLE 
    | ENCRYPTION | ENFORCED | END | ENGINE | ESCAPE | EVENT | EXCHANGE 
    | EXECUTE | FILE | FIRST | FIXED | FOLLOWING | GLOBAL | HASH 
    | IMPORT_ | INSERT_METHOD | INVISIBLE | KEY_BLOCK_SIZE | LAST | LESS 
    | LEVEL | MAX_ROWS | MEMORY | MIN_ROWS | MODIFY | NO | NONE | OFFSET 
    | PACK_KEYS | PARSER | PARTIAL | PARTITIONING | PASSWORD | PERSIST | PERSIST_ONLY 
    | PRECEDING | PRIVILEGES | PROCESS | PROXY | QUICK | REBUILD | REDUNDANT 
    | RELOAD | REMOVE | REORGANIZE | REPAIR | REVERSE | ROLLBACK | ROLLUP 
    | ROW_FORMAT | SAVEPOINT | SESSION | SHUTDOWN | SIMPLE | SLAVE | SOUNDS 
    | SQL_BIG_RESULT | SQL_BUFFER_RESULT | SQL_CACHE | SQL_NO_CACHE | START | STATS_AUTO_RECALC | STATS_PERSISTENT 
    | STATS_SAMPLE_PAGES | STORAGE | SUBPARTITION | SUPER | TABLES | TABLESPACE | TEMPORARY 
    | THAN | TIME | TIMESTAMP | TRANSACTION | TRUNCATE | UNBOUNDED | UNKNOWN 
    | UPGRADE | VALIDATION | VALUE | VIEW | VISIBLE | WEIGHT_STRING | WITHOUT 
    | MICROSECOND | SECOND | MINUTE | HOUR | DAY | WEEK | MONTH
    | QUARTER | YEAR | AGAINST | LANGUAGE | MODE | QUERY | EXPANSION
    | BOOLEAN | MAX | MIN | SUM | COUNT | AVG | BIT_AND
    | BIT_OR | BIT_XOR | GROUP_CONCAT | JSON_ARRAYAGG | JSON_OBJECTAGG | STD | STDDEV
    | STDDEV_POP | STDDEV_SAMP | VAR_POP | VAR_SAMP | VARIANCE
    ;

tableName
    : (identifier_ DOT_)? identifier_
    ;

columnName
    : (identifier_ DOT_)? identifier_
    ;

columnNames
    : LP_ columnName (COMMA_ columnName)* RP_
    ;

indexName
    : identifier_
    ;

expr
    : expr logicalOperator_ expr
    | notOperator_ expr
    | LP_ expr RP_
    | booleanPrimary
    ;

notOperator_
    : NOT | NOT_
    ;

logicalOperator_
    : OR | OR_ | XOR | AND | AND_
    ;

booleanPrimary
    : booleanPrimary IS NOT? (TRUE | FALSE | UNKNOWN | NULL)
    | booleanPrimary SAFE_EQ_ predicate
    | booleanPrimary comparisonOperator predicate
    | booleanPrimary comparisonOperator (ALL | ANY) subquery
    | predicate
    ;

comparisonOperator
    : EQ_ | GTE_ | GT_ | LTE_ | LT_ | NEQ_
    ;

predicate
    : bitExpr NOT? IN subquery
    | bitExpr NOT? IN LP_ expr (COMMA_ expr)* RP_
    | bitExpr NOT? BETWEEN bitExpr AND predicate
    | bitExpr SOUNDS LIKE bitExpr
    | bitExpr NOT? LIKE simpleExpr (ESCAPE simpleExpr)?
    | bitExpr NOT? (REGEXP | RLIKE) bitExpr
    | bitExpr
    ;

bitExpr
    : bitExpr VERTICAL_BAR_ bitExpr
    | bitExpr AMPERSAND_ bitExpr
    | bitExpr SIGNED_LEFT_SHIFT_ bitExpr
    | bitExpr SIGNED_RIGHT_SHIFT_ bitExpr
    | bitExpr PLUS_ bitExpr
    | bitExpr MINUS_ bitExpr
    | bitExpr ASTERISK_ bitExpr
    | bitExpr SLASH_ bitExpr
    | bitExpr DIV bitExpr
    | bitExpr MOD bitExpr
    | bitExpr MOD_ bitExpr
    | bitExpr CARET_ bitExpr
    | bitExpr PLUS_ intervalExpression_
    | bitExpr MINUS_ intervalExpression_
    | simpleExpr
    ;

simpleExpr
    : functionCall
    | literal
    | columnName
    | simpleExpr COLLATE (STRING_ | identifier_)
    | variable_
    | simpleExpr OR_ simpleExpr
    | (PLUS_ | MINUS_ | TILDE_ | NOT_ | BINARY) simpleExpr
    | ROW? LP_ expr (COMMA_ expr)* RP_
    | EXISTS? subquery
    | LBE_ identifier_ expr RBE_
    | matchExpression_
    | caseExpression_
    | intervalExpression_
    ;

functionCall
    : aggregationFunction | specialFunction_ | regularFunction_ 
    ;

aggregationFunction
    : aggregationFunctionName_ LP_ distinct? (expr (COMMA_ expr)* | ASTERISK_)? RP_ overClause_?
    ;

aggregationFunctionName_
    : MAX | MIN | SUM | COUNT | AVG | BIT_AND | BIT_OR
    | BIT_XOR | JSON_ARRAYAGG | JSON_OBJECTAGG | STD | STDDEV | STDDEV_POP | STDDEV_SAMP
    | VAR_POP | VAR_SAMP | VARIANCE
    ;

distinct
    : DISTINCT
    ;

overClause_
    : OVER (LP_ windowSpecification_ RP_ | identifier_)
    ;

windowSpecification_
    : identifier_? partitionClause_? orderByClause? frameClause_?
    ;

partitionClause_
    : PARTITION BY expr (COMMA_ expr)*
    ;

frameClause_
    : (ROWS | RANGE) (frameStart_ | frameBetween_)
    ;

frameStart_
    : CURRENT ROW | UNBOUNDED PRECEDING | UNBOUNDED FOLLOWING | expr PRECEDING | expr FOLLOWING
    ;

frameEnd_
    : frameStart_
    ;

frameBetween_
    : BETWEEN frameStart_ AND frameEnd_
    ;

specialFunction_
    : groupConcatFunction_ | windowFunction_ | castFunction_ | convertFunction_ | positionFunction_ | substringFunction_ | extractFunction_ 
    | charFunction_ | trimFunction_ | weightStringFunction_
    ;

groupConcatFunction_
    : GROUP_CONCAT LP_ distinct? (expr (COMMA_ expr)* | ASTERISK_)? (orderByClause (SEPARATOR expr)?)? RP_
    ;

windowFunction_
    : identifier_ LP_ expr (COMMA_ expr)* RP_ overClause_
    ;

castFunction_
    : CAST LP_ expr AS dataType RP_
    ;

convertFunction_
    : CONVERT LP_ expr COMMA_ dataType RP_
    | CONVERT LP_ expr USING identifier_ RP_ 
    ;

positionFunction_
    : POSITION LP_ expr IN expr RP_
    ;

substringFunction_
    :  (SUBSTRING | SUBSTR) LP_ expr FROM NUMBER_ (FOR NUMBER_)? RP_
    ;

extractFunction_
    : EXTRACT LP_ identifier_ FROM expr RP_
    ;

charFunction_
    : CHAR LP_ expr (COMMA_ expr)* (USING ignoredIdentifier_)? RP_
    ;

trimFunction_
    : TRIM LP_ (LEADING | BOTH | TRAILING) STRING_ FROM STRING_ RP_
    ;

weightStringFunction_
    : WEIGHT_STRING LP_ expr (AS dataType)? levelClause_? RP_
    ;

levelClause_
    : LEVEL (levelInWeightListElement_ (COMMA_ levelInWeightListElement_)* | NUMBER_ MINUS_ NUMBER_)
    ;

levelInWeightListElement_
    : NUMBER_ (ASC | DESC)? REVERSE?
    ;

regularFunction_
    : regularFunctionName_ LP_ (expr (COMMA_ expr)* | ASTERISK_)? RP_
    ;

regularFunctionName_
    : identifier_ | IF | CURRENT_TIMESTAMP | LOCALTIME | LOCALTIMESTAMP | NOW | REPLACE
    ;

matchExpression_
    : MATCH columnNames AGAINST (expr matchSearchModifier_?)
    ;

matchSearchModifier_
    : IN NATURAL LANGUAGE MODE | IN NATURAL LANGUAGE MODE WITH QUERY EXPANSION | IN BOOLEAN MODE | WITH QUERY EXPANSION
    ;

caseExpression_
    : CASE simpleExpr? caseWhen_+ caseElse_? END
    ;

caseWhen_
    : WHEN expr THEN expr
    ;

caseElse_
    : ELSE expr
    ;

intervalExpression_
    : INTERVAL expr intervalUnit_
    ;

intervalUnit_
    : MICROSECOND | SECOND | MINUTE | HOUR | DAY | WEEK | MONTH
    | QUARTER | YEAR | SECOND_MICROSECOND | MINUTE_MICROSECOND | MINUTE_SECOND | HOUR_MICROSECOND | HOUR_SECOND
    | HOUR_MINUTE | DAY_MICROSECOND | DAY_SECOND | DAY_MINUTE | DAY_HOUR | YEAR_MONTH
    ;

literal
    : parameterMarker
    | number
    | TRUE
    | FALSE
    | NULL
    | LBE_ identifier_ STRING_ RBE_
    | HEX_DIGIT_
    | string
    | identifier_ STRING_ collateClause_?
    | (DATE | TIME | TIMESTAMP) STRING_
    | characterSet_? BIT_NUM_ collateClause_?
    ;

subquery
    : 'Default does not match anything'
    ;

orderByClause
    : ORDER BY orderByItem (COMMA_ orderByItem)*
    ;

orderByItem
    : (columnName | number | expr) (ASC | DESC)?
    ;

dataType
    : dataTypeName_ dataTypeLength? characterSet_? collateClause_? UNSIGNED? ZEROFILL? | dataTypeName_ LP_ STRING_ (COMMA_ STRING_)* RP_ characterSet_? collateClause_?
    ;

dataTypeName_
    : identifier_ identifier_?
    ;

dataTypeLength
    : LP_ NUMBER_ (COMMA_ NUMBER_)? RP_
    ;

characterSet_
    : (CHARACTER | CHAR) SET EQ_? ignoredIdentifier_ | CHARSET EQ_? ignoredIdentifier_
    ;

collateClause_
    : COLLATE EQ_? (STRING_ | ignoredIdentifier_)
    ;

ignoredIdentifier_
    : identifier_ (DOT_ identifier_)?
    ;

ignoredIdentifiers_
    : ignoredIdentifier_ (COMMA_ ignoredIdentifier_)*
    ;
