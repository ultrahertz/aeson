module Typed.TH (benchmarks) where

import Control.Applicative
import Criterion
import Data.Aeson hiding (Result)
import Data.ByteString.Builder as B
import Data.ByteString.Lazy as L
import Twitter.Generic
import Typed.Common

encodeDirect :: Result -> L.ByteString
encodeDirect = B.toLazyByteString . fromEncoding . toEncoding

encodeViaValue :: Result -> L.ByteString
encodeViaValue = encode

benchmarks :: Benchmark
benchmarks =
  env ((,) <$> load "json-data/twitter100.json" <*> load "json-data/jp100.json") $ \ ~(twitter100, jp100) ->
  bgroup "th" [
      bgroup "direct" [
        bench "twitter100" $ nf encodeDirect twitter100
      , bench "jp100" $ nf encodeDirect jp100
      ]
    , bgroup "viaValue" [
        bench "twitter100" $ nf encodeViaValue twitter100
      , bench "jp100" $ nf encodeViaValue jp100
      ]
    ]
