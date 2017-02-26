-- |
-- Module      : Foundation.Primitive.Endianness
-- License     : BSD-style
-- Maintainer  : Haskell Foundation
-- Stability   : experimental
-- Portability : portable
--
-- Set endianness tag to a given primitive. This will help for serialising
-- data for protocols (such as the network protocols).
--

{-# LANGUAGE CPP #-}

module Foundation.Primitive.Endianness
    (
      ByteSwap
      -- * Big Endian
    , BE(..), toBE, fromBE
      -- * Little Endian
    , LE(..), toLE, fromLE
    ) where

import Foundation.Internal.Base
import Foundation.Internal.ByteSwap

#if !defined(ARCH_IS_LITTLE_ENDIAN) && !defined(ARCH_IS_BIG_ENDIAN)
import Foundation.System.Info (endianness, Endianness(..))
#endif

-- | Little Endian value
newtype LE a = LE { unLE :: a }
  deriving (Show, Eq, Ord, Typeable)

-- | Big Endian value
newtype BE a = BE { unBE :: a }
  deriving (Show, Eq, Ord, Typeable)

-- | Convert a value in cpu endianess to big endian
toBE :: ByteSwap a => a -> BE a
#ifdef ARCH_IS_LITTLE_ENDIAN
toBE = BE . byteSwap
#elif ARCH_IS_BIG_ENDIAN
toBE = BE
#else
toBE = BE . (if endianness == LittleEndian then byteSwap else id)
#endif
{-# INLINE toBE #-}

-- | Convert from a big endian value to the cpu endianness
fromBE :: ByteSwap a => BE a -> a
#ifdef ARCH_IS_LITTLE_ENDIAN
fromBE (BE a) = byteSwap a
#elif ARCH_IS_BIG_ENDIAN
fromBE (BE a) = a
#else
fromBE (BE a) = if endianness == LittleEndian then byteSwap a else a
#endif
{-# INLINE fromBE #-}

-- | Convert a value in cpu endianess to little endian
toLE :: ByteSwap a => a -> LE a
#ifdef ARCH_IS_LITTLE_ENDIAN
toLE = LE
#elif ARCH_IS_BIG_ENDIAN
toLE = LE . byteSwap
#else
toLE = LE . (if endianness == LittleEndian then id else byteSwap)
#endif
{-# INLINE toLE #-}

-- | Convert from a little endian value to the cpu endianness
fromLE :: ByteSwap a => LE a -> a
#ifdef ARCH_IS_LITTLE_ENDIAN
fromLE (LE a) = a
#elif ARCH_IS_BIG_ENDIAN
fromLE (LE a) = byteSwap a
#else
fromLE (LE a) = if endianness == LittleEndian then a else byteSwap a
#endif
{-# INLINE fromLE #-}
