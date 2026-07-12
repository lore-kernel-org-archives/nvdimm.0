Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08874145B11
	for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 16:48:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783874937; cv=none; b=E4QcPhzXXOhjDNvPUDg3zVgONK4el8oUQwLOg8Qpwud00uI7jrw2zgQ+gBqkF3+QxTsjAF3JNvNnV3NDyruzvs40V6DdU0KEhkTMo3SRsZu5apWivcxVcO4wFDJND/Sat6bKgp6PWRym431LEUzlyzDG7GR4Pdh4n37vxTeaRCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783874937; c=relaxed/simple;
	bh=Qt4v/dZ/atl2InBXlF6Qg0mek0k2Z3U8e5b5n5VxTGE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YC68S0JpSPCoU+scdqGqDbdsS2A6v3K6bkZwnYkZz51+ZoW0xFFhq3kYrwLufMw+T7iUW6dvR/t6NcWKA/rjS6NTCJIZ5Uv0aSb37a5+d5fqztmAJ53hyOM+duxsAKFRWYl5AIKVxtSICeTE4x8xhro8JlNqJPQOOZeQgqk95OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=AlZ2b4ad; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="AlZ2b4ad"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-51c0006ea8eso17023181cf.1
        for <nvdimm@lists.linux.dev>; Sun, 12 Jul 2026 09:48:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783874935; x=1784479735; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=jgHRZ2oQs3owZnO2hrgFCKNrpUU4ppVoDgnNpxTspCQ=;
        b=AlZ2b4adlO/33HSkXMDDCW149dMGp+mJTCqNFPJRs+iYc8dTvU6nR68GE605F2mYri
         +++4Oiw+5heupEolKZsrf7ncCLih34vOnH4lCnKtGRxai6RDQ15X593PrJPbumse8iUr
         Ywrluk89EoUnwvpJRYFWtw+YnzgMea69CkXn9faE0GCAtfv2MYzh1FMe5jtJDUMKlr5l
         IqSmB9DBPmjweiyZOhqS0S/b2FqnyE/OVTdTqGthpBoX3NluFTRsQWG8xkoBhr3WYFJb
         KQx0r/cQmtaF/TT2k9QtrzM6laAF8sZMFWULbJpL0MzPhuhZV58UrBsnAgkzaqIpkggo
         oh/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783874935; x=1784479735;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jgHRZ2oQs3owZnO2hrgFCKNrpUU4ppVoDgnNpxTspCQ=;
        b=OkWPTDbNgJNeta3Eh0rNE7z8ruhJBlYNeeigGD3VQ3n49zzfkbHrjdnqL8+QQcrFRF
         r3CSWzlNtLg6i8KRd8Y0iNgJ+O37KjSSeqJey1m8tgi04V8HHvy/0vpVKDFJqFNNmsF7
         Mckn7Iy8JwvvuJibuPFQTRKmEDqoP+gXN66IQJqkeaEHG+8ebFMZOWGnVKU5+2rs/rb9
         6nXiiQANixFQng3Hk2SEh0vQiC/gmIh6X4HT7yVyOTcrFL2hs7pdecCmeq4M/KLdxlBB
         JGeP3/FEdEPoiXQObRfPXpKkU+xCRl+IKBflhvObQUEt0GP+6q92/cg256CgDaOUP7nv
         yqIA==
X-Forwarded-Encrypted: i=1; AHgh+RqhUYc6xeYHQgrmPRhWYGHMSgQRBdZ4yZ3OsvcGQ/KXMRbkzl8rj9P8ueICtCZntTFS8iXNSe4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/tGam6oeJ06r6NxUPEzpMr1WHe4CdJkecxSOdRsDNEGi6YWEZ
	iORI3g++o/zThg3vfkMKs8+9+BoPMmJ7plmMV1x1NwYedq0VDEApz4WnYmSdjZIwX4Y=
X-Gm-Gg: AfdE7cncVjgkBmqQeGaaOY6WWiOhrDlhKP9RIPlBEr6oAsZfpZrhg3oz+0VaDdVhBpT
	UJyUc5krCdlKHUu5uj0dCccUbHtx+4erZ5ymywak8ZhRPypyBhYVC1BSMbB2CZX3xJiG8Bkz/Qs
	JRbOqHuD/1MJjWL1i4zzRFoNZs0yQAYNKrfZ5PD5sX+wNCjzForTFtN7eNrxadfr7XoOOP8b9ol
	O26MsXUA8sebR15xRCcFamMzYL+CKbr0k34r1pnfKP1N863j1MHTw13vi2xkfIXYsTuGRT7zrgO
	ZELssdWDWkEgZN1l4FGK26ktRqXGg8PYjJ4jpxv2qNgfCmJae2os6jWSRGRVHS+p7486ZCCiLJm
	QfuiC8gftHaYIK0xhS1A9ZEShkRGLa0PIBJFUiGYkRf+b5rYSlc2tG1hVVLVUl3yV1miFw3poiT
	9d/g3LHiFatJnKRhFC5HN1RsGmDarpCCBjFKEGbsFzmS1Q/6bBKXNt8UVPYkGcQjiwuQbD
X-Received: by 2002:a05:622a:7281:b0:51b:f98f:ea5e with SMTP id d75a77b69052e-51cc9d5d02amr30044441cf.22.1783874935089;
        Sun, 12 Jul 2026 09:48:55 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51caae20a40sm68575071cf.15.2026.07.12.09.48.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Jul 2026 09:48:53 -0700 (PDT)
Date: Sun, 12 Jul 2026 12:48:49 -0400
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org,
	driver-core@lists.linux.dev, nvdimm@lists.linux.dev,
	linux-kselftest@vger.kernel.org, kernel-team@meta.com,
	david@kernel.org, osalvador@suse.de, gregkh@linuxfoundation.org,
	rafael@kernel.org, dakr@kernel.org, djbw@kernel.org,
	vishal.l.verma@intel.com, dave.jiang@intel.com,
	alison.schofield@intel.com, akpm@linux-foundation.org,
	ljs@kernel.org, liam@infradead.org, vbabka@kernel.org,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	shuah@kernel.org
Subject: Re: [PATCH v7 00/10] dax/kmem: atomic whole-device hotplug via sysfs
Message-ID: <alPFcfjlzSHYk3jA@gourry-fedora-PF4VCD3F>
References: <20260712154505.3564379-1-gourry@gourry.net>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260712154505.3564379-1-gourry@gourry.net>

On Sun, Jul 12, 2026 at 11:44:54AM -0400, Gregory Price wrote:
> The dax kmem driver onlines memory during probe using the system
> default policy, with no atomic control for the state of an entire
> region at runtime - only by toggling individual memory blocks.
> 

Took a look at Sashiko reviews.

All are either false-positive, pre-existing issues on isolated patches
that are actually resolved by later patches, or something we previously
agreed on (WARN/pass in phase 2 of offline_and_remove_memory_ranges).

So series is clean as-is.

~Gregory
