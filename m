Received: from mail-qk1-f180.google.com (mail-qk1-f180.google.com [209.85.222.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CD952EAD09
	for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 17:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768410745; cv=none; b=Fk9B3l0lXGzVGHgjAjBeWSzyIhNn5ld3Pw5FmnxHgjqRHwubbCh54CD8uWjA/Og3fwhxUHw2163FJ/66/uqjBYuFGHk3ru6wMy0MzO1wsHinUGIq0v03Sp1uuATHCQIWSjpx+Fw1sb1zVYMt0bxtKEVh0w5rXAnyvIcqi6+G+JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768410745; c=relaxed/simple;
	bh=p77GEG+mB5piIaHLHG+aeaef+IL/MBZBpezD3NGQ3tE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=stewVjQcITxFWQTcbqihK+6n/UQpRRNKXo6hGuTzZzSv2MdWaO53a7hvJYoK5wj0JIa6UJ2SAn/+him/pSkagJ4TfDD5a2bBIv8qB+h29aLXKMKM4fGE5MNJWHOp/gFtkPiJ9SpG3k5nJOQVMhQ3Rqz7PWtuoMpijBkOfNZyOmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Wn13rNqi; arc=none smtp.client-ip=209.85.222.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Wn13rNqi"
Received: by mail-qk1-f180.google.com with SMTP id af79cd13be357-8b1bfd4b3deso2660185a.2
        for <nvdimm@lists.linux.dev>; Wed, 14 Jan 2026 09:12:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1768410743; x=1769015543; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=cLZK+PqSn6nIdPCyk8+Al7PM0O31XRvufO9b7gKXcTo=;
        b=Wn13rNqi2pkbM+nNfoz7H0qwwD9Aos8HpXnfcLF9qiysqtUMlOsQNBRh6mxRQQe7v+
         yXuy2h+fzYM16QT8BgQHey1ModQwja1HNQk4Qffv3ASBkYJuH2uvUWEyZanOisQO/K2Q
         06FsezDrLG4eM5Y9UmQzNABR7wOdG5MsWbqzOieRTDjwFJjq+tBodrWF35YkXPDnm0y6
         uhpC/vAwwBpGHfZrmscr6l6fXiV0tob1BdY1ZG9/s/NAYuJHDE0OsV74znWUzbP/UYrY
         vuFv0BavOO36B0GodmeIG6mS9iB2mBL0TLyUStnW8fLZmMiIU8tLDnKzzunWCizn6y0A
         BcKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768410743; x=1769015543;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cLZK+PqSn6nIdPCyk8+Al7PM0O31XRvufO9b7gKXcTo=;
        b=fYi8sZDpZzL9ZDfzxyfGmtcGDojF68hi8BL/ge2iEkyNq/AIIkNcNxBwT8//ZeF8k2
         W3/ub7vx8gmXmdqqeCI//fcMP1PsidoxQpoAmZtpNgxbAmWfELnfFYf23Q9JvRZ4YgTr
         5ZEqion9kp425Br6A+3lFjWMm+64Hap2dlKcFR6YF5pyGGddvAh73ijeeee6avDEcKtA
         SRSvPmxje7gJQ7ihZuaQxApx/yHml/Wf9RPEJ/cIPURVg2zWJfoYNnUOqNveOQgN88L4
         LvfkAzLrVi83f1CnSNB24A/iIa/2c5MOmO8+JJbpmqGg+PeVLEVWp1mnJyiRwnpJf3A1
         OJvg==
X-Forwarded-Encrypted: i=1; AJvYcCVah3GO+YkXIdMdp5RSufD2X+focByYXLLEb5Ssm1q1gffPqvwEEP6+S+3TkHp40plfcdgPPvA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz0f3dIUalCg7hvkKhWEY98C9MVvvs/DSRWeluGkk3gYGRZj2Un
	x2Isq5iu9pHlJBBY3k5H3yKSdWKJWZy/Hkojg4oOYZwBfbRhUqQhJqhno87Z1LpzRO8=
X-Gm-Gg: AY/fxX73+xKzGq04x3gpRvYhvZVPtfYV5/IpZJtZAnxE45EBFYii89fntR/VsxIY57P
	1NLEYGqhmLQeLwfxxkSGOOlW/0whh2HCTwVE2vv0ajvPxW5zoW2MdlRnhnfnRC2HGcWMHRKytBZ
	wp64EDVQ5TlVX7mjii1aoBLUTSK3vuvl4OJiv4UVz54onLyH42RX0FjjEEoTiDtUXsD/Sj8BQfp
	hMT82SjrYw1USTvwFtuQatbPDrN+9IX+wKGhldsnajDVXHRe3r0PbcsavL5L3rpPlL5QQTYa6hj
	zBpUQpZ+cCIIdTZl42vxSkMPsavMxK0R4ykO0/yafxIS3wCohCgvbdKwf/yA91tsgLjKFathLeQ
	tvQf+8yMCo1E9v88gfWQCrHK+ZTo1XImpcQcR/luR6LM4jDz5FrbqqpgLkjH9jtkL5eyoOl3dUB
	j7Zr/l/XwfVrmqF+GXntwGEroj5gPVU3kpIeVv+e4TQciHFE7U3Hs2QUiYR1T6bKBO0VwQPCeJH
	PMfzdsB
X-Received: by 2002:a05:620a:f03:b0:8b2:d6eb:8203 with SMTP id af79cd13be357-8c531808de8mr358190785a.69.1768410743009;
        Wed, 14 Jan 2026 09:12:23 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c530be76d1sm201549285a.48.2026.01.14.09.12.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Jan 2026 09:12:22 -0800 (PST)
Date: Wed, 14 Jan 2026 12:11:49 -0500
From: Gregory Price <gourry@gourry.net>
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	kernel-team@meta.com, dan.j.williams@intel.com,
	vishal.l.verma@intel.com, dave.jiang@intel.com, mst@redhat.com,
	jasowang@redhat.com, xuanzhuo@linux.alibaba.com,
	eperezma@redhat.com, osalvador@suse.de, akpm@linux-foundation.org
Subject: Re: [PATCH 2/8] mm/memory_hotplug: extract __add_memory_resource()
 and __offline_memory()
Message-ID: <aWfOVd3_GGTNHKNt@gourry-fedora-PF4VCD3F>
References: <20260114085201.3222597-1-gourry@gourry.net>
 <20260114085201.3222597-3-gourry@gourry.net>
 <c4ed9675-269c-4764-86d5-87f4f83fc74d@kernel.org>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c4ed9675-269c-4764-86d5-87f4f83fc74d@kernel.org>

On Wed, Jan 14, 2026 at 11:14:21AM +0100, David Hildenbrand (Red Hat) wrote:
> On 1/14/26 09:51, Gregory Price wrote:
> > Extract internal helper functions with explicit parameters to prepare
> > for adding new APIs that allow explicit online type control:
> > 
> >    - __add_memory_resource(): accepts an explicit online_type parameter.
> >      Add MMOP_SYSTEM_DEFAULT as a new value that instructs the function
> >      to use mhp_get_default_online_type() for the actual online type.
> >      The existing add_memory_resource() becomes a thin wrapper that
> >      passes MMOP_SYSTEM_DEFAULT to preserve existing behavior.
> > 
> >    - __offline_memory(): extracted from offline_and_remove_memory() to
> >      handle the offline operation with rollback support. The caller
> >      now handles locking and the remove step separately.
> 
> 
> I don't understand why this change is even part of this patch, can you
> elaborate? You don't add any "explicit parameters to prepare for adding new
> APIs that allow explicit online type control" there.
> 
> So likely you squeezed two independent things into a single patch? :)
>
> Likely you should pair the __add_memory_resource() change with the
> add_memory_driver_managed() changed and vice versa.
> 

I tried to keep the refactor work and the new feature work separate.

But yeah that's fair i can just add them to the respective path.

> > +	/* Use system default online type from mhp_get_default_online_type(). */
> > +	MMOP_SYSTEM_DEFAULT,
> 
> I don't like having fake options as part of this interface.
> 
> Why can't we let selected users use mhp_get_default_online_type() instead?
> Like add_memory_resource(). We can export that function.
> 

Wasn't sure if that was preferred, I can do that.

I think i eventually ended up doing that in DAX anyway, I just never
came back around to clean it up.

ack.

~Gregory
