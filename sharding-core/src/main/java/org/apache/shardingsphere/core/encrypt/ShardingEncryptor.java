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

package org.apache.shardingsphere.core.encrypt;

import java.util.Properties;

/**
 * Sharding encryptor.
 *
 * @author panjuan
 */
public interface ShardingEncryptor {
    
    /**
     * Get sharding encryptor type.
     * 
     * @return sharding encryptor type
     */
    String getType();
    
    /**
     * Get properties.
     * 
     * @return properties
     */
    Properties getProperties();
    
    /**
     * Set properties.
     * 
     * @param properties properties
     */
    void setProperties(Properties properties);
    
    /**
     * Encode.
     * 
     * @param plaintext plaintext
     * @return ciphertext
     */
    String encode(String plaintext);
    
    /**
     * Decode.
     * 
     * @param ciphertext ciphertext
     * @return plaintext
     */
    String decode(String ciphertext);
}