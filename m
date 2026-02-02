Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8E102EC0A6
	for <nvdimm@lists.linux.dev>; Mon,  2 Feb 2026 21:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770068231; cv=none; b=Ch+fsYrPWMUFwmri6+STmZuA+ozpWaeRLvpaBM6aPGqv/NyC0UIPG+1iGtxYQRN+pBE8RmfAz6Fs0KdTd160e2y1+sCxjlnODH8pOSbZ6v3yeJkRYqe1l9Zrv6FPuykMC1Bkwpedlznbfy9xG10hlFftszHS4FkuNa0eMeSTpAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770068231; c=relaxed/simple;
	bh=kWEypPVGwJEMybutYPQAIuFoGDfenpYyYtSso4g6JH4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=INzTPW3BsD/iia7p2ZhNntHLfxVVC2d0quxm2kVWK9D+fuVI1UIwh5OaqM9jTQEua0WNu8smjllTy+PXJElJlo8IyHcqSTC7eepUuskHCZLdZj+6QQcFXkoZz4sJWuaJXwq+fc/oJxdYA3Jhto3IDJhq2GbSllLc3gJQg9WpJTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=seLRk54F; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="seLRk54F"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-8c9eedc2363so338531985a.1
        for <nvdimm@lists.linux.dev>; Mon, 02 Feb 2026 13:37:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1770068228; x=1770673028; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8laAOVGcrjt3grREBpdlanB8iPI5gP36V5MB+/CpDTw=;
        b=seLRk54FlPTXZInsZliXMdmOFHtwfRgiGcy0a3+ioz8olQoynGH4i/19fzk8gYn+fo
         92stCSElPAdvT2QI/9qHWkc/FzWQK9651lZZAW2DaI0UqqcmKhprLC/9PtK/H22kieF9
         92S2USo9DDxtguHbqjPKFOxBckbXPvawU2wZzy79eILhgeFjCGpwFBD9SYTpKHX7dUHy
         wpRtsRfpy6VX03A99Vl+vv4MoB9dEmuVpQNhAoSkDcX9fAiQ86XtdZ8ZN4ilF/k/wq6D
         z7e3NYYbpy5+9kc15BjLHTR7ARdIGz3PzwBmTLRSxgxa2fR6XP2QlxApEV/sRDcraeVF
         4WlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770068228; x=1770673028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8laAOVGcrjt3grREBpdlanB8iPI5gP36V5MB+/CpDTw=;
        b=Dc5EN3mh2TnNp9/fUShVZN/eH4TdOo56P0ESJQHEA9AHUiVb9vioUNu/9byx1QQ746
         kjkX+8DiZNhFrVBxwH+jTqC2kIxesLE5QDo+2JQgYgxBlZMc9CgKcxMIQpc7BwF9vNKb
         REa/8kFdbRh6p3qz+Rfx+bvDH3gv8bIlGvuUk5LtLeTaSgEt4FSlzjxNUVHxGADADuQa
         5pZbw3dE8yKDVxO5aJA0CU++oyBAl9RuXimeANSMcCGnvoYSOxpgObYeM3Ptcsly4S2N
         2G/5cs3KMow/IDi5+vsMzmlT9g9+DGRYyJiUd286M7tQQFDnYoRdj1YRTDhNPsAPX6ZV
         PQ+w==
X-Forwarded-Encrypted: i=1; AJvYcCUTAULjA9AxoF/L9SmHtTfnuqVyVkOsxkzIZUPBG6wK9PMFa0K37ICn23BL5Nqr5lfBhq79t0o=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxlg3bXjiDus3d3If/7krGgfADlVGvKsQ1NmTyNzgKVAebEEnEb
	agHi3b06/ocVc2uS57CyBaV8LjH2KridxZFZmd47JaWP1Blb7BnAdlGHnulNPvTAakA=
X-Gm-Gg: AZuq6aJy/H/9KgV6jEzcBQiXeReXEDhEnSYKkokM8IH9bmrywPtpek/LdEdjawGlIcd
	5vIJBCXHd0rbAZ/BHl0+NwUxsc7Lv9YZ6H1gu/EIIHmpkalRL6HkthaweSUMId8YN+r7hr3IvDB
	/AgODc/LmDTPhkUrJcAQHMEk3l6/oPj21p5BLoodyTeAMf7zBjiwXLpBRYsJRnZTwwqtuHXo8qh
	YzKK4ZhzRSmhWKBWgLB8H7P1zzD/YCKdgFE/mkoDaU8ozD7EKDQFeDpD/T2RgApxQ+bbUuWcPRV
	D8/h5zrzMu/oPtcCu4t2pOYpAQk1fwG147LxT8ZW+zww5KGi3Di9b2zgoyJh+RCE33ZO8fY/BJ0
	LKRD3tpeqnMvrmZ7RRj0xRTnfDqVI4fODiXNqwk2ZN53S2AQi3PWx4z+aBH1msFbJzObsXMuZJ4
	Kq5eU3n/VUGQuljeIGngA4MhQdQGOakpBa55dfRjonoCoBzl5y87Fd0yNofd3Awf/Ai/dhdQ==
X-Received: by 2002:a05:620a:46a6:b0:8c6:e22b:25f7 with SMTP id af79cd13be357-8c9eb1fc204mr1562950785a.18.1770068228565;
        Mon, 02 Feb 2026 13:37:08 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8c711d61c6fsm1317392985a.47.2026.02.02.13.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Feb 2026 13:37:08 -0800 (PST)
Date: Mon, 2 Feb 2026 16:37:05 -0500
From: Gregory Price <gourry@gourry.net>
To: Jonathan Cameron <jonathan.cameron@huawei.com>
Cc: linux-mm@kvack.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org, kernel-team@meta.com, dave@stgolabs.net,
	dave.jiang@intel.com, alison.schofield@intel.com,
	vishal.l.verma@intel.com, ira.weiny@intel.com,
	dan.j.williams@intel.com, willy@infradead.org, jack@suse.cz,
	terry.bowman@amd.com, john@jagalactic.com,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 2/9] mm/memory_hotplug: add __add_memory_driver_managed()
 with online_type arg
Message-ID: <aYEZAUJMLWvaug50@gourry-fedora-PF4VCD3F>
References: <20260129210442.3951412-1-gourry@gourry.net>
 <20260129210442.3951412-3-gourry@gourry.net>
 <20260202172524.00000c6d@huawei.com>
 <aYDmor_ruasxaZ-7@gourry-fedora-PF4VCD3F>
 <20260202184609.00004a02@huawei.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202184609.00004a02@huawei.com>

On Mon, Feb 02, 2026 at 06:46:09PM +0000, Jonathan Cameron wrote:
> > 
> > I can add a cleanup-patch prior to use the enum, but i don't think this
> > actually enables the compiler to do anything new at the moment?
> 
> Good point. More coffee needed (or sleep)
> 
> It lets sparse do some checking, but sadly only for wrong enum assignment.
> (Gcc has -Wenum-conversion as well which I think is effectively the same)
> I.e. you can't assign a value from a different enum without casting.
> 
> It can't do anything if people just pass in an out of range int.
> 

Which, after looking a bit... mm/memory_hotplug.c does this quite a bit
internally - except it uses a uint8_t

Example:

static int try_offline_memory_block(struct memory_block *mem, void *arg)
{
        uint8_t online_type = MMOP_ONLINE_KERNEL;
        uint8_t **online_types = arg;
	... snip ...
}

int offline_and_remove_memory(u64 start, u64 size)
{
        uint8_t *online_types, *tmp;
	... snip ...
        online_types = kmalloc_array(mb_count, sizeof(*online_types),
                                     GFP_KERNEL);
}

So that's fun.

I'm not sure it's worth the churn here, but happy to do it if there are
strong opinions.

---

David do you have thoughts here?

~Gregory
