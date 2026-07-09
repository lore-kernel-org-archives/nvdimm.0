Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E638A347524
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 17:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783617325; cv=none; b=DzyMxCQPtB+WgzbTgPwxR8sT2xPCU8g/OAqyyU0Ae4u3g6wtbPeyA9w+2VP9ARVkVjE0lvfRlkkYjAt0NOkus3j7y8cC6LwENziu2OmE7Yf5Ony6tgr+bl+VehrGogWg4nOU9ANcPr9i3qWJsGmOFKpVu1NnFQKkUxcDYZwcS5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783617325; c=relaxed/simple;
	bh=SzROYG8BwD/EB/+MUjQ4u1vhoaHs3/zZwllWfULF+qU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GU6UXce7BIR8O+P2lnuH1ru6I9Hpf/98mhtFPtXBIWOH+8njDKOCMzhmRMIJEgDF7lTRgTgaCnkQH7b2DmQDoVtCE7h8h+cUmwNr2JXGHYlEVCAiWaKLMyltkWWXNscr4zhR0066hr2jYyDVRx0RiIFmuRdggccK9wL0WZ4LtKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=Hrn35nOI; arc=none smtp.client-ip=209.85.219.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="Hrn35nOI"
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8ef1dc934d1so1159886d6.0
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 10:15:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783617323; x=1784222123; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=46UkRwT/i/djJx+KopbYZyKUrVPhRVpwIJdu7TzJpII=;
        b=Hrn35nOIfeGnrCiFaOEVOhKWW88rGGJrF+pOlvdk2Jn8bLawYbt0V4oA11mAhzm0Fd
         A1FRnrQZzMv4pZ5hzkqA4DV6BfUp3fAS8FFFGhamhAJ80tcGi3ZwjMxonFeFc7mPH23L
         sfusu7v/en3yIdzpgS4MhGEPYrmjpSbkv4LR58iMVyozBtEGcD/HXQAnEB4HcAzTz7HZ
         ivlCZNTEo00lkV/yb92E+XWzkHRTdDYVRBFw4+H40X04LQrhM9j9FCiiW2BEEPZSmXTE
         nqCeN4kJScY7Wu9Bqy4GGCDT+h04P+YafXEk2Iz3V4xnlUiWHkH6u+mgtQ9qNe3q+g1c
         K8vA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783617323; x=1784222123;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=46UkRwT/i/djJx+KopbYZyKUrVPhRVpwIJdu7TzJpII=;
        b=fS/at61viQ4WqisGp/asvMtUzYUuKEthVOKCEX5mim1Rab0apVvJ3IjwtIDcJM7o9N
         F3XNK/1F99hpMlKinTgaZQpRD0+UgW6G/s5kxmFmjlowLovkpmbKEC8GcgL6YpUrsGuF
         OK2TLL3TxHTeq2f5JXEjgLZyZuuKTQyLiNsyE57lIcHUbcGx2I02cnLxIL4ax9hJrz8t
         hvRRHrZmlC09j0bccYfz27UYPiww8mTJq7kVtZHQWzgKbMFLfrk2lC0YraijIyuiqusm
         IqMSdY/sexa5McWdhFhU/PHGLBFTCNOXlCxfSACsCatywP7HwN7YH2+toius5g4zJ2S5
         6w0A==
X-Forwarded-Encrypted: i=1; AHgh+Rrnu8gagvi/ihQhj1cHrZavw7omAerSJxiS6fu1vA0meXJ5TTCW/xslxwMQNqGNJ8UP9MGpdD8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxG4lIicw3ZBt2lBXPWD5Dqnl4K7pRHD+8bo2zU4w0YC1QcEPc1
	jNOafGSyLWZReHsL0r7W0FV73wwp/3QIUjsVKfFWownv8pAsNOMgHMb4DKrV+izDToc=
X-Gm-Gg: AfdE7cnKD/KyEMzaAG4Gow1gHALBgRNGrqQONCINbp9vGVFK/MRVxSAdB5Ttw6TYS1j
	xrbuFJED7s8HpRU/BiRhDfnX4pw6huQAOML+iKq2Fg5C2KImIUfjOcZrbfjdo7w4Lm4rki5eqm7
	bBqyUb7PLAuEnjP/QpTal2peTC6JF17UKlUKpMgXjjNdGxywPKn6lSDCeqpqPXP26mDzpOXFbPu
	DPCLdRJoPGqz1wsGsUqR7pq2UBo1j1ZbBK9n6a98iyhW4ISrsEwkSDtboagtTwhoRu83QvjHc1v
	AhTG2/GcPoQlezGe6H1HN4azBGI6AEizYvn9OwUzfYk5yB0jet2P+yN5wvyVRoru48sersbf48T
	Rkl4NV2JeiB/097jkCIZ4TSpMaNie575h/LT0MCmk/F6yhsDj+fd36eUPThF5o95tiiSUw6lglG
	APF5LtZYejfAOUZMgoiTtwm9tgqDj30vDrVNJEdgrlbWIa/Tij7uqvdzkgWWN/yNDilzoj
X-Received: by 2002:a05:6214:6014:b0:8e9:f45f:107b with SMTP id 6a1803df08f44-90242143c3amr1641696d6.34.1783617322803;
        Thu, 09 Jul 2026 10:15:22 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8ffd7c1d8fcsm22085656d6.25.2026.07.09.10.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 10:15:22 -0700 (PDT)
Date: Thu, 9 Jul 2026 13:15:17 -0400
From: Gregory Price <gourry@gourry.net>
To: Richard Cheng <icheng@nvidia.com>
Cc: linux-mm@kvack.org, nvdimm@lists.linux.dev,
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, linux-kselftest@vger.kernel.org,
	kernel-team@meta.com, david@kernel.org, osalvador@suse.de,
	gregkh@linuxfoundation.org, rafael@kernel.org, dakr@kernel.org,
	djbw@kernel.org, vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org, iweiny@kernel.org,
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com
Subject: Re: [PATCH v6 06/10] mm/memory_hotplug: add
 offline_and_remove_memory_ranges()
Message-ID: <ak_XJWglABmKfSiU@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-7-gourry@gourry.net>
 <ak9ee95F7pJpCKMo@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak9ee95F7pJpCKMo@MWDK4CY14F>

On Thu, Jul 09, 2026 at 04:45:51PM +0800, Richard Cheng wrote:
> On Tue, Jun 30, 2026 at 05:18:38PM +0800, Gregory Price wrote:
> > +/**
> > + * offline_and_remove_memory_ranges - offline and remove multiple memory ranges
> > + * @ranges: array of physical address ranges to offline and remove
> > + * @nr_ranges: number of entries in @ranges
> > + *
> > + * Offline and remove several memory ranges as one operation, serialized
> > + * against other hotplug operations by a single lock_device_hotplug().
> > + *
> > + * This offlines all ranges before removing any of them.  If offlining any
> > + * range fails, the entire process is reverted and nothing is removed.
> > + * This provides a fully atomic semantic for unplugging an entire device.
> > + *
> > + * Each range must be memory-block aligned in start and size.
> > + *
> > + * Return: 0 on success, negative errno otherwise.  On failure no range has
> > + * been removed.
> > + */
> 
> I think this can return 1, and it shouldn't.
> device_offline() returns 1 when a block is already offline, and phase 1 passes that value through as-is.
> 

I just realized try_offline_memory_block() already clamps the value to 0

static int try_offline_memory_block(struct memory_block *mem, void *arg)
{
...
    rc = device_offline(&mem->dev);
...
    /* Ignore if already offline. */
    return rc < 0 ? rc : 0;
}

But this is a bit non-obvious, let me see about making this a little
bit clearer.

~Gregory
