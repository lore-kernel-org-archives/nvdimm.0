Received: from mail-qk1-f179.google.com (mail-qk1-f179.google.com [209.85.222.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCF4A383C64
	for <nvdimm@lists.linux.dev>; Thu,  9 Jul 2026 14:57:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783609035; cv=none; b=hm2sAXAlGHJbt5K4PCC74qC9M56HYOpb1Os89urmql1b0JNnZux24CPpQvtZ2OsGM4RYR5fKoXDEpVZN/obxEmWhSaLm+YRC5L4xi7kFdAjUnfYSH8oXmy4HdQRQG6wV70sYBaGgmQiJf50BA/LUNMHf82OGdYbTdPXl+Uq9ncI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783609035; c=relaxed/simple;
	bh=tjgdvByW5WBZqyhrd7wFuCriBR6z1oBevpMfu6TVGNs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rG5aLTmTDBpUwLLdSRMtKbcFOyJwo5AXOXwYll1lqXSvxgD6JrJfO6Glub0DRW5Vm79HyB3uPFz1eIvJokvw8j/Gl0ErxUHtpxtSuQO599yU1/0ItSteEX22ARDjvyIxsgc61Wd2A1Qw8L1uTw25Y82E30Pjhq4dxqPP0Z+GsI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=ZTLBa0ce; arc=none smtp.client-ip=209.85.222.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="ZTLBa0ce"
Received: by mail-qk1-f179.google.com with SMTP id af79cd13be357-92e99ef0902so51747485a.2
        for <nvdimm@lists.linux.dev>; Thu, 09 Jul 2026 07:57:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1783609033; x=1784213833; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cUc0YxX2OnLyX2sI3kys65ZvVtk8+5Y5AOwoYWzDFOM=;
        b=ZTLBa0ceG67g1q2FGpiKFLvVoxdq1Iy89naBq5rfMr3Lj8Yix8xtSeAus67hqa7WkS
         6dcQ585CruB0sgTfylKOqVK8UXJ4+3truqTTwVUr1UQ4ttXgku8Uz9sdtu/T92PlQfVQ
         2D5rckM/zadRQgXx6jbOXcze3WJ0vwhG8Q2lZ4LHUyojjhuS7dCiz6ttOWiJIS/cgZPR
         v/SWOBBgpAGaZo8LmiUgwPHwiOfVXX0lSnKPKe3XUA2wDwADrX/fHDMTvyfybEkdFbCo
         ENSyyxQegzG4+p9ZOo3VZjmeB2Nxvaio1KHzPu6EpB1wlkXfTasgTgSewb5YNFjkoBLT
         jQig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783609033; x=1784213833;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cUc0YxX2OnLyX2sI3kys65ZvVtk8+5Y5AOwoYWzDFOM=;
        b=it75pDb22hyvmrcMBoDBaHfTXDMPEKilZ2lUbEF8VBn4ChzTxlD3pq/PtR1Rp7f5ua
         Q8i4gs3A2fTKbaZ6WhbF8lLta68xllKUzmNYRd4LKwbTnwtDs4aOAjhbLRq69U7YHExf
         dDo2JBuQjfVAzlOb3i2mvyhuYdskp5z0FsjZ+VUdOovq/aGH5oyCjKPEzKk7TdO9Wl6l
         8m8Iyvbk4BajPv6DHcrmGYj4yi7qu9+5wRYBy2daREyS5OE2f9pyAhnqJFEw89bIHl7d
         nW53rkAlikSqiI4g0MBT6isx5g/qhT7bqzFbDLiMrFbODxw30PqVtppx4fPk5DH2+cfy
         dMDw==
X-Forwarded-Encrypted: i=1; AHgh+Rpg9Te13ihss/SjDJpsdtIuD7IIsieblDrDNpZ3/oh+lcb3XcbdbHjk/wOTR6abdnA512OyLbA=@lists.linux.dev
X-Gm-Message-State: AOJu0YxJtB3rGk0zZJIyI10tcVPEYvDU5itMLhigpunHeT0JFp/f1MLa
	9bCx3a7ei734pZXezQuwKIns3tqcMEtP9O+mdw+gor8PjFKMHFJhNf7jzj7IYYnAgGs=
X-Gm-Gg: AfdE7cnUg6pQshqNdbPACx1WfMA3EMW7+bgUiUJNw7nELoLcVCZNlLUCsDKq/ttnNy7
	IddWKBBxBLKu7I7e1kEsLeZDrOvq0lMXYYIcai7KWr9GiqFnRvjUKmDrb7pAk0MPMnLyoPz/ofm
	6TuPOASb/L9mWPcLEA1XhdzkjbiIbaobuTekOrdEvCJJEf6Mwkq/WlUECtbqgajBXixYjm/zRoO
	nrDC561DA9ZMrNh+awcXE0w9p0sVbHwiEnjSOYpS5CC71+NjMs389Jut761rrlbHfTFq8DzKGnv
	wMejakL+xyU7itKkRJgHAVpfOHnLOr6nplfc7b1Qj41zK9QiZO2ZcDUy6BLHe3Uda2WJO4DoRbK
	21aHd5XcEUaNKXqWyIyGprzQvzw3ogICEQfdHKl4mUeYixLrgF01e8d69FAC4x1SIlvzggXbqjB
	Io+94gPSWkmr372h991S0twu+jnK29RxIkbr1kya4iqYWhYzZRGu7lwEx6UJ9sp2yj8mOW
X-Received: by 2002:a05:620a:460f:b0:92d:e54e:72db with SMTP id af79cd13be357-92ecf54a01bmr728326285a.22.1783609032712;
        Thu, 09 Jul 2026 07:57:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-92e90cedfe0sm1725553985a.43.2026.07.09.07.57.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2026 07:57:12 -0700 (PDT)
Date: Thu, 9 Jul 2026 10:57:07 -0400
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
	Smita.KoralahalliChannabasappa@amd.com, apopple@nvidia.com,
	Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v6 09/10] dax/kmem: add sysfs interface for atomic
 whole-device hotplug
Message-ID: <ak-2w-aHp5huBa2N@gourry-fedora-PF4VCD3F>
References: <20260630211842.2252800-1-gourry@gourry.net>
 <20260630211842.2252800-10-gourry@gourry.net>
 <ak9TSx-I-53dX6fx@MWDK4CY14F>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ak9TSx-I-53dX6fx@MWDK4CY14F>

On Thu, Jul 09, 2026 at 04:07:31PM +0800, Richard Cheng wrote:
> > +	if (dax_kmem_state_is_online(data->state)) {
> > +		dev_warn(dev, "Hotplug regions stuck online until reboot\n");
> > +		any_hotremove_failed = true;
> > +		return;
> 
> Hi Gregory,
> 
> I suppose data->state is only updated when writing to the new daxX.Y/state file?
> If the blocks are offlined through the old per-block interface, data->state
> still says online and we will hit this early return.
> Everything is leaked and a later rebind fails -EBUSY.
> 
> Current behavior is using remove_memory(), and it succeeds on offlined blocks
> and fails safely with -EBUSY on online ones, no offlining from unbind context
> either way.
> 
> Your changelog state "on unbind fallback to legacy if still online", but the
> fallback only runs for data->state == MMOP_OFFLINE.
> Maybe drop this early return and just try dax_kmem_remove_ranges() here too?
> 

Hm, I think you are right.  When doing some testing I bounced between
tests which race with dax/state and block/state, and I missed the
obvious case of the whole device being offline but dax/state being stale.

I think this entire chunk actually just drops to:

dax_kmem_remove_ranges(dev_dax, data);

And the internal error catches the condition to the log.

Thanks! I will spin a new version next week.

~Gregory
