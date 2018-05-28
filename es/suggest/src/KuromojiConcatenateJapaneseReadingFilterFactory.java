/*
 * Licensed to Elasticsearch under one or more contributor
 * license agreements. See the NOTICE file distributed with
 * this work for additional information regarding copyright
 * ownership. Elasticsearch licenses this file to you under
 * the Apache License, Version 2.0 (the "License"); you may
 * not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */

package org.elasticsearch.index.analysis;

import org.apache.lucene.analysis.TokenStream;
import org.apache.lucene.analysis.ja.ConcatenateJapaneseReadingFilter;

import org.elasticsearch.common.settings.Settings;
import org.elasticsearch.env.Environment;
import org.elasticsearch.index.IndexSettings;

public class KuromojiConcatenateJapaneseReadingFilterFactory extends AbstractTokenFilterFactory {
    private static final String PARAM_MAX_NUM_TOKENS = "maxNumTokens";
    private static final String PARAM_MODE = "mode";

    private int maxNumTokens;
    private int mode;

    public KuromojiConcatenateJapaneseReadingFilterFactory(IndexSettings indexSettings, Environment environment, String name, Settings settings) {
        super(indexSettings, name, settings);
        mode = settings.getAsInt(PARAM_MODE, ConcatenateJapaneseReadingFilter.DEFAULT_MODE);
        maxNumTokens = settings.getAsInt(PARAM_MAX_NUM_TOKENS, ConcatenateJapaneseReadingFilter.DEFAULT_MAX_OUTPUT_TOKEN_SIZE);  
    }

    @Override
    public TokenStream create(TokenStream tokenStream) {
        return new ConcatenateJapaneseReadingFilter(tokenStream, maxNumTokens, mode);
    }
}
