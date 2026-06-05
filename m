Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6E82FE071
	for <nvdimm@lists.linux.dev>; Fri,  5 Jun 2026 05:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780638425; cv=none; b=J37gUtBp1CsCeTP61AV4FJEVvTe6iifUBZU39j0/USgFh4tERUq1vsEGx6/fLdACgYtUcKvpnWohQOkftaUfphSPvfZIM3UtDE56eKPocBSPk4wNyBxCBgPjMe5qv1rWvFSt4w9pf0WWxSnSp0VhoiZWU0Yrrv6OziwZYqH4YAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780638425; c=relaxed/simple;
	bh=aJTgQ30kt0uFdu2pZY5iDO3RjT8mlphDE/zuDEG5amY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bGkjixc1E2rRNq5FopEh6zdmb5VIUFM4PipUUx0Vt1AgclukuR4LhWZJxwPzwdAA4c2q+abzD1yBpKHlQ7DdwPcUIH9ULRJ0hMrrPHq1mkc1Ht2T9PpgzpXr6U5BYDGfS1QMDgFHrFC3vajIa6pfljOb7AjYPk8M2tWc93O1xHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OjN4uNDu; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OjN4uNDu"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490b3637b90so12697785e9.3
        for <nvdimm@lists.linux.dev>; Thu, 04 Jun 2026 22:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780638422; x=1781243222; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fjDrLfKQSx9/iTAOpM8mEBvBfa+kxAhmd9fKCaMvT60=;
        b=OjN4uNDuYclg5IDfwwNyjM61A60fboZHAHLHku7cHF+HpqKXVCNyLy46TCdDoDfbkN
         kThqVcP6xlrUv3eLUtHKWBecyVc/HRHHEIZY2jeWLrW4l/if3enEuDU92LZDGjUPOWWV
         AD5KM4Vmvxv0q1VrInAcBvlo1VhL8XiHIn1asAx+46XNHx4f6jcieCccmN2pLaZ5JyJM
         DwVChdy/q0fMsJrUFAuTZV1a4Tkvu9GZhXlZickbR/XKvS/aocAGtNFdzvXersYVyzXY
         vNQH6i37p4WjNO07sibr5PC1/bNEGMvG8naik9ZwW/OnLQAQhgV9fxooWNuu+OIPWFxZ
         yFPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780638422; x=1781243222;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fjDrLfKQSx9/iTAOpM8mEBvBfa+kxAhmd9fKCaMvT60=;
        b=Bouq/GByxwtlk46IDe5g12kp0DK+toC7rrMa0KpuyyQPHU+bwHc8LReYahv+Yv4Xsb
         qnu7rGp7I0lcsH6DQmoo4Zmp53HqQSbEmoirFHToJBp9R7W1T263okGumfTg6m2iChaX
         zYNdBCCN5c7PpTnSkdwT2EQqYKneehDjwtDo3OmwcQ3cj3Of1yThd1Gvt/M7uuJ2yLr1
         NkGidId8u3OGWoIvLz5Vd+Uqw4QdmRRFV2+283CLeMym8F5QO/vl1lwGcqZw9dTUkT8T
         N0YIgMhNmujla6Pv8j8pSNSduI4+JM5CEBiBXseK/c0l+XhBIJg/tZAGqoUr4hoYy2S3
         Fobw==
X-Forwarded-Encrypted: i=1; AFNElJ9dUt37aQO84gDdr4pQBVKV6k7vOaQ6pRYJmR0qM8Zm6BkwjdHkp/Zy4ygzDhqNwfgKydmnji0=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywrv7O35UczfHj8RVfRC4zSlWWhIEoge6W2E86SpWArhPSBkuYU
	e7nuCsna7udrl985trEeNiXdpp0fwkS3PTZ+++8k5YeMmQNceXsgiCjL
X-Gm-Gg: Acq92OGm5csEa7pKYWTiaMBpjOr7PnaA/zs3PKkMZuUudmvo0i+AitNTSfI2ssQRuY7
	mmskZ6NTs2yAKlfBjwthNy1vYXFDpQNIB2Nksxaxd8d5CfNaVIpT/dj1QeJrTeik/XFfMLXhPFw
	JKd0yg8AhmjLQ8JBAPPCrXhC9LqIXtM4OAJdj0QqDJHtxS/UbUARrqWE9GvAqnLVUwWcYiJZ6QD
	4p2DFmIAxlEzfoQv29T7IYZL63vi159m2kE3xl4dk76/6S7CefeLRMV2wmdVkP713xabT9SCwF9
	PnQfxXo0xsw8VX4mV4BkZzdcgRJPGM2U3Su1BQodE3Igk09bQafiC+XeMUSo5MJbop5S1lamuHx
	8KNkNU1a+6oFm8+82aNd/XenBhqxxK/h8yu5Ehza3NcdmvdrLcQDGMPYKRmeH6KYqXPEDpTnoWm
	ohkyoUlr5M5B8/FTsp4vAfstVsf0DhBA==
X-Received: by 2002:a05:600c:c493:b0:490:bb3e:30c2 with SMTP id 5b1f17b1804b1-490c25f1682mr28690675e9.18.1780638421991;
        Thu, 04 Jun 2026 22:47:01 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4601f2ec711sm21676813f8f.12.2026.06.04.22.47.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Jun 2026 22:47:01 -0700 (PDT)
Date: Fri, 5 Jun 2026 08:46:57 +0300
From: Dan Carpenter <error27@gmail.com>
To: Dmitry Ilvokhin <d@ilvokhin.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Dan Williams <djbw@kernel.org>,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>, Ira Weiny <ira.weiny@intel.com>,
	Miguel Ojeda <ojeda@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Marco Elver <elver@google.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Andrew Morton <akpm@linux-foundation.org>, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	kernel-team@meta.com
Subject: Re: [PATCH v5 3/4] cleanup: Annotate guard constructors with nonnull
Message-ID: <aiJi0WcYE8FZt-jO@stanley.mountain>
References: <cover.1780064327.git.d@ilvokhin.com>
 <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <85fee12eec20abfcf711443518e8f0caec982a86.1780064327.git.d@ilvokhin.com>

On Tue, Jun 02, 2026 at 07:12:52AM +0000, Dmitry Ilvokhin wrote:
> Add __nonnull_args() to unconditional guard constructors so the compiler
> warns when NULL is statically known to be passed:
> 
> - DEFINE_GUARD(): re-declare the constructor with __nonnull_args().
> - __DEFINE_LOCK_GUARD_1(): annotate the constructor directly.
> 
> DEFINE_LOCK_GUARD_0() needs no annotation: its constructor takes no
> pointer arguments (.lock is hardcoded to (void *)1).
> 
> Define the __nonnull_args() macro in compiler_attributes.h, following
> the existing convention for attribute wrappers. Deliberately not named
> '__nonnull', to avoid clashing with glibc's __nonnull() when kernel and
> userspace headers are combined (User Mode Linux for example).
> 
> Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
> ---
> Miguel, I dropped your Acked-by due to the rename. Went with
> __nonnull_args() (over __knonnull()). Happy to restore your tag if that
> spelling works for you.
> 

Sparse doesn't like an empty __nonnull_args() at all.

./include/linux/spinlock.h:608:1: error: an expression is expected before ')'
./include/linux/spinlock.h:619:1: error: an expression is expected before ')'
./include/linux/spinlock.h:631:1: error: an expression is expected before ')'

Shouldn't we specify the arguments which are non-NULL?
__nonnull_args(1)?

regards,
dan carpenter


