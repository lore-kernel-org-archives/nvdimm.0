Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21C6328B7EA;
	Sat, 23 May 2026 08:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779526151; cv=none; b=kzcMp8hjy2K89L/bphnCCZ1NslaCaT0N2AUj4BnWHM35OZGP/MWS27yzC4C7PJyCcPPNTw0dI2fqpB/A43U222evKtrd39/abD4W5xNHvXqaEhZb7CNZS1cSAKzko+6Q0HEsnpdUAThoVRsUcXWqIpeDDkLehXOSQDckzH/Q0JI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779526151; c=relaxed/simple;
	bh=rIV80BSF/ksu/g9Crj/Epd732hvq/y8iCEdRoFuZp5o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ni1Gfg7LLAnF9dOzKgPU8Q/AhSdy8OG71+3gMyx3glKtdBTNvZvA+GfR5w4YbEkXpLRBUOngFS9+9V4H2PfaqYXPbE/C2K1ntov1ExfCkeeiL0NmR5gM1fpAiVLuqEFFCHjScdtD0YKMaTB+U9cgxzJHw7WvsaY4NndLe7GPmX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=BEyJ5yKD; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="BEyJ5yKD"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=OIFL42ts8Sf4xjq6jPC8EPpfJjsyni5NkXr7Ls4uWvM=; b=BEyJ5yKDAtQEBSEkgEHomhh/t6
	8g/FUOs39ZYNeN1t/E6qqVQSekVBzPRQrN+8Nb0c5u+ehc2y3QQ1KNx6iMUxzPQWAfonHx02tZjvk
	u1JWmIfYcqbfZxWad7pbTGiZ7ZXYIXjmrBpYkXCZLw/V4QwRWC2d8l/2srSHhZzp4YydCkzRnVpEd
	14Q2RloJ6QyBTs8GioqHDZvsC5LPY+E27c4N4bOvz77qsKIIO/Xf+Ge5xRNJMHXTHWURUM513l0MC
	hFqvZ2eibgsQjDRiihKkgY8hqYGKhH52CYHwsJZJkmRYhLlzuSBJqN3xeQzMgGfQJ3Ee4aQN0EgkZ
	GG52gQiQ==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by desiato.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wQi2X-00000006BfH-44qK;
	Sat, 23 May 2026 08:49:02 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 3DCB6300462; Sat, 23 May 2026 10:49:01 +0200 (CEST)
Date: Sat, 23 May 2026 10:49:01 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v4 3/4] cleanup: Annotate guard constructors with
 __nonnull()
Message-ID: <20260523084901.GF3102624@noisy.programming.kicks-ass.net>
References: <cover.1779286416.git.d@ilvokhin.com>
 <0ab092c41e18e6a7db703547d87e6b632d6f79b2.1779286416.git.d@ilvokhin.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0ab092c41e18e6a7db703547d87e6b632d6f79b2.1779286416.git.d@ilvokhin.com>

On Thu, May 21, 2026 at 07:18:03AM +0000, Dmitry Ilvokhin wrote:
> Add __nonnull() to unconditional guard constructors so the compiler
> warns when NULL is statically known to be passed:
> 
> - DEFINE_GUARD(): re-declare the constructor with __nonnull().
> - __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.
> 
> DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
> pointer arguments (.lock is hardcoded to (void *)1).
> 
> Define the __nonnull() macro in compiler_attributes.h, following the
> existing convention for attribute wrappers.
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> Acked-by: Miguel Ojeda <ojeda@kernel.org>

The build robot found something to hate in this one. I think you're on
Cc there. It looks to me like clang-23 is confused somehow, but who
knows.

> ---
>  include/linux/cleanup.h             | 4 +++-
>  include/linux/compiler_attributes.h | 6 ++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/cleanup.h b/include/linux/cleanup.h
> index ea95ca4bc11c..8f8d588b5595 100644
> --- a/include/linux/cleanup.h
> +++ b/include/linux/cleanup.h
> @@ -397,6 +397,7 @@ static __maybe_unused const bool class_##_name##_is_conditional = _is_cond
>  	__DEFINE_GUARD_LOCK_PTR(_name, _T)
>  
>  #define DEFINE_GUARD(_name, _type, _lock, _unlock) \
> +	static __always_inline __nonnull() _type class_##_name##_constructor(_type _T); \
>  	DEFINE_CLASS(_name, _type, if (_T) { _unlock; }, ({ _lock; _T; }), _type _T); \
>  	DEFINE_CLASS_IS_GUARD(_name)
>  
> @@ -497,7 +498,8 @@ static __always_inline void class_##_name##_destructor(class_##_name##_t *_T) \
>  __DEFINE_GUARD_LOCK_PTR(_name, &_T->lock)
>  
>  #define __DEFINE_LOCK_GUARD_1(_name, _type, ...)			\
> -static __always_inline class_##_name##_t class_##_name##_constructor(_type *l) \
> +static __always_inline __nonnull()					\
> +class_##_name##_t class_##_name##_constructor(_type *l)			\
>  	__no_context_analysis						\
>  {									\
>  	class_##_name##_t _t = { .lock = l }, *_T = &_t;		\
> diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
> index c16d4199bf92..10a1410eb3e2 100644
> --- a/include/linux/compiler_attributes.h
> +++ b/include/linux/compiler_attributes.h
> @@ -230,6 +230,12 @@
>   */
>  #define   noinline                      __attribute__((__noinline__))
>  
> +/*
> + *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Attributes.html#index-nonnull
> + * clang: https://clang.llvm.org/docs/AttributeReference.html#nonnull
> + */
> +#define __nonnull(x...)			__attribute__((__nonnull__(x)))
> +
>  /*
>   * Optional: only supported since gcc >= 8
>   * Optional: not supported by clang
> -- 
> 2.53.0-Meta
> 
