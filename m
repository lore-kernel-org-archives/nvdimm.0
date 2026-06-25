Received: from mail-dy1-f170.google.com (mail-dy1-f170.google.com [74.125.82.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CEC13909A8
	for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 09:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782380077; cv=none; b=Ga3GqBxFbW4UkXmMnhQY7j4GnQh1x410lq7J88MQBEL/nHpIfMtw6jBFHOSPuG+FUistsvZBvAen9VrjR0S09iUGbWnh92oBpSe84d1AQoJ5h9uJxhTFGTkE4rjVLvImLv9WOO7c3NacJnJai/PsW8J2H7/IacsHaVfz7rWNmpo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782380077; c=relaxed/simple;
	bh=9nMFJcXJ2+U7+N/MThZ5PTmUFgeso7NSMjClz15v5OE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gwUEIrTKo+FAw2V8BlFDd5jGRESoEsF3DGw01DfXt8eQooFPAXwlxZNrWAjcgUaMdISSO1qwVTtE27KTY2yZiKST8SPHa3Q9z8LvEYFCl6al4xqkcrOYjDiCRatBegfBqLIxfVpFYY1D0s0t0w/Ogkrh/B7VvYndcgckTASwIpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=aJbrljCO; arc=none smtp.client-ip=74.125.82.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aJbrljCO"
Received: by mail-dy1-f170.google.com with SMTP id 5a478bee46e88-30c52f96f60so3873365eec.1
        for <nvdimm@lists.linux.dev>; Thu, 25 Jun 2026 02:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782380071; x=1782984871; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:from:to:cc:subject:date:message-id:reply-to;
        bh=EXXLxtO1asfwxF78X/30o4nSWm0EU7VHxFXckaOFZZY=;
        b=aJbrljCOVVl1fKPavL/JPq8q0CpSIg28ijvWhEVP6Jp6+Rimx6/qhYRsGUmUMbTOiD
         tzSD80+U0u/j+zBJ7qAPlmIy8PV8h4ygENAWBB22dIVdpvJsCDjLlAPhH+ZQ+l2Y0Gak
         Q52b4W9otIvEngALCnsuoj45JSHOVkzykuwgMbfIa64fhmuLqv4UM6aj9ZyahV+kCKqS
         KcBBWc3bX5WTpux8PE5AS9Vn6l+GTR77Bx0VcUGYbbCHInSAR071+v9sSBhH/pci6i4k
         Jb8AmWyATnXeNCgwTib48pGO8creQin+4Oya/loCrKv2CpfxGOh3cTLPBN4VkrM+s2UM
         V6XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782380071; x=1782984871;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:date:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EXXLxtO1asfwxF78X/30o4nSWm0EU7VHxFXckaOFZZY=;
        b=INeEW3+1+QJL/fPD5MQSrPM/IqEENfCEsC/cvY4RJl+Ti37FSF+3lzqBgN7ensXT7l
         my3I5tCCgQsdnoWYzLuqsb0WDTpROoG9cmQ7mYniOpJ4oKZxfX2WlQqJdktqV5XpJTDM
         1KO41Ancyk5No2jMlj/rAKwc4WixYZB9P4GeirTQ5yN6SiL9e6y55zOtj0pz3vvE7hVx
         2JWA1e6V/0pfqisnJcRUIFMErQqjlABWJwsSRZmnyeSYQlRWKfqW9t+c0RcQhP9g4gYM
         1VvKArOe61PFHKnExrNvy5nJioTZmq10X2P/WWkYb5vSDFG1eLyX+eQtD9YigD6lLIjq
         XImA==
X-Forwarded-Encrypted: i=1; AHgh+RoquyiExXSqCfOPopYyr7nQmYQBCiXcSjrc4jLnpaFFnCETWAbKM7JNKtwhrlqH6NVCl1W8JYQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxVNl5CM1IMrU8gLN6g60Q+gn6j85uKMF6hD4cvJfvHPAuuuzuy
	LPTJEFxhWAbRA73Pl1Fs5B4cidswllSeybQtbEirgpZG1Y0osDVre/RO
X-Gm-Gg: AfdE7cmNiRNEwOBVsuQr0vhXMBAGsy/0M6l+CQbg25z/h0090Q9OiH7tBEWOvV72mly
	VgNjLW+0jKOV0A7ZZ71o1vQ+kStzIuMP5GRf3PlxBgh/9r54r38cKLnUHMSOrJP+hDnJ6nHhuty
	NQCLdi/j3uhH+RH1baODtuqNgN4a4dhcrXa7McWlNMFikTyGk+s+PH1SH2mD4yncZMZP+wHPqk1
	2nu8RkOqcEnyQNHy45YIwqYNchlGp9487nC/+TNgXFNKZYDi5Q0E9O4HBwDMi/gssJo4n1uuw3f
	V4xejtqL+UEdGJ5HAiO5HzzoI0BUHddowEOG2c2TE+8fgfzcfaFiBubueo8s/AajW0t+kSvlm36
	F7crU0PXV54cbKGh0khamCPrRmr10K2PSy/vbIH1B1bxodsy6ev2QT1dg2j2UIRYTAPA27OLSXv
	BrENHk5aohYtiY/+NbCpRgM24ls3cwLrQ/aSJNoV6GuqeOhvfFwMGk6/qhLO1OaAKxXftl
X-Received: by 2002:a05:7301:a83:b0:304:de28:1b16 with SMTP id 5a478bee46e88-30c84dac8e5mr1913396eec.28.1782380071247;
        Thu, 25 Jun 2026 02:34:31 -0700 (PDT)
Received: from AnisaLaptop.localdomain (c-73-170-217-179.hsd1.ca.comcast.net. [73.170.217.179])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-30c7c4c9dafsm8680698eec.1.2026.06.25.02.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2026 02:34:30 -0700 (PDT)
From: Anisa Su <anisa.su887@gmail.com>
X-Google-Original-From: Anisa Su <anisa.su@samsung.com>
Date: Thu, 25 Jun 2026 02:34:29 -0700
To: Dave Jiang <dave.jiang@intel.com>
Cc: Anisa Su <anisa.su887@gmail.com>, linux-cxl@vger.kernel.org,
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev,
	Dan Williams <djbw@kernel.org>, Jonathan Cameron <jic23@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>, Ira Weiny <iweiny@kernel.org>,
	Alison Schofield <alison.schofield@intel.com>,
	John Groves <John@groves.net>, Gregory Price <gourry@gourry.net>,
	Ira Weiny <ira.weiny@intel.com>
Subject: Re: [PATCH v6 7/7] cxl/test: Add Dynamic Capacity tests
Message-ID: <ajz2JTDDoW6wRX5m@AnisaLaptop.localdomain>
References: <20260523095043.471098-1-anisa.su@samsung.com>
 <20260523095043.471098-8-anisa.su@samsung.com>
 <d58b398a-eba8-4b4e-b1ab-cfed64fe11e8@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d58b398a-eba8-4b4e-b1ab-cfed64fe11e8@intel.com>

On Mon, Jun 08, 2026 at 05:24:08PM -0700, Dave Jiang wrote:
> 
> 
> On 5/23/26 2:50 AM, Anisa Su wrote:
> > From: Ira Weiny <ira.weiny@intel.com>
> > 
> > cxl_test provides a good way to ensure quick smoke and regression
> > testing.  The complexity of DCD and the new sparse DAX regions
> > required to use them benefits greatly with a series of smoke tests.
> > 
> > The only part of the kernel stack which must be bypassed is the actual
> > irq of DCD events.  However, the event processing itself can be tested
> > via cxl_test calling directly into the event processing.
> > 
> > In this way the rest of the stack; management of sparse regions, the
> > extent device lifetimes, and the dax device operations can be tested.
> > 
> > Add Dynamic Capacity Device tests for kernels which have DCD support.
> > 
> > Signed-off-by: Ira Weiny <ira.weiny@intel.com>
> > Signed-off-by: Anisa Su <anisa.su887@gmail.com>
> 
> A nit below. Otherwise
> 
> Reviewed-by: Dave Jiang <dave.jiang@intel.com>
> 
[snip] 
> > +test_event_reporting()
> > +{
> > +	# Test event reporting
> > +	# results expected
> > +	num_dcd_events_expected=2
> > +
> > +	echo "Test: Prep event trace"
> > +	echo "" > /sys/kernel/tracing/trace
> > +	echo 1 > /sys/kernel/tracing/events/cxl/enable
> > +	echo 1 > /sys/kernel/tracing/tracing_on
> > +
> > +	inject_extent ${device} $base_ext_dpa $base_ext_length ""
> > +	remove_extent ${device} $base_ext_dpa $base_ext_length
> 
> Missing the tag arg
> 
> DJ

Fixed, thanks!

Anisa
> 
> > +
> > +	echo 0 > /sys/kernel/tracing/tracing_on
> > +
> > +	echo "Test: Events seen"
> > +	trace_out=$(cat /sys/kernel/tracing/trace)
> > +
> > +	# Look for DCD events
> > +	num_dcd_events=$(grep -c "cxl_dynamic_capacity" <<< "${trace_out}")
> > +	echo "     LOG     (Expected) : (Found)"
> > +	echo "     DCD events    ($num_dcd_events_expected) : $num_dcd_events"
> > +
> > +	if [ "$num_dcd_events" -ne $num_dcd_events_expected ]; then
> > +		err "$LINENO"
> > +	fi
> > +}
> > +
> > +
> > +# ========================================================================
> > +# main()
> > +# ========================================================================
> > +
> > +modprobe -r cxl_test
> > +modprobe cxl_test
> > +
> > +# The mock stamps a single cxl_mem instance with this serial (0xDCDC).
> > +# That memdev's DC partition is advertised as sharable in CDAT and is
> > +# the only one that can host the shared-extent tests.  All other DCD
> > +# memdevs stay non-sharable and host the rest of the suite.
> > +MOCK_DC_SHARABLE_SERIAL=56540
> > +
> > +readarray -t memdevs < <("$CXL" list -b cxl_test -Mi | jq -r '.[].memdev')
> > +
> > +sharable_mem=""
> > +sharable_decoder=""
> > +sharable_bus=""
> > +sharable_device=""
> > +sharable_dra_size=""
> > +
> > +for cand in ${memdevs[@]}; do
> > +	cand_dra=$($CXL list -m $cand | jq -r '.[].dynamic_ram_a_size')
> > +	if [ "$cand_dra" == "null" ]; then
> > +		continue
> > +	fi
> > +	cand_decoder=$($CXL list -b cxl_test -D -d root -m "$cand" |
> > +		  jq -r ".[] |
> > +		  select(.volatile_capable == true) |
> > +		  select(.nr_targets == 1) |
> > +		  select(.max_available_extent >= ${cand_dra}) |
> > +		  .decoder")
> > +	if [[ -z "$cand_decoder" ]]; then
> > +		continue
> > +	fi
> > +	cand_serial=$($CXL list -m $cand | jq -r '.[].serial')
> > +	cand_bus=`"$CXL" list -b cxl_test -m ${cand} | jq -r '.[].bus'`
> > +	cand_device=$($CXL list -m $cand | jq -r '.[].host')
> > +
> > +	if [ "$cand_serial" == "$MOCK_DC_SHARABLE_SERIAL" ]; then
> > +		if [ -z "$sharable_mem" ]; then
> > +			sharable_mem="$cand"
> > +			sharable_decoder="$cand_decoder"
> > +			sharable_bus="$cand_bus"
> > +			sharable_device="$cand_device"
> > +			sharable_dra_size="$cand_dra"
> > +		fi
> > +	else
> > +		if [ -z "$mem" ]; then
> > +			mem="$cand"
> > +			decoder="$cand_decoder"
> > +			bus="$cand_bus"
> > +			device="$cand_device"
> > +			dra_size="$cand_dra"
> > +		fi
> > +	fi
> > +
> > +	if [ -n "$mem" ] && [ -n "$sharable_mem" ]; then
> > +		break
> > +	fi
> > +done
> > +
> > +echo "TEST: non-sharable bus:${bus} decoder:${decoder} mem:${mem} device:${device} size:${dra_size}"
> > +echo "TEST: sharable     bus:${sharable_bus} decoder:${sharable_decoder} mem:${sharable_mem} device:${sharable_device} size:${sharable_dra_size}"
> > +
> > +if [ "$decoder" == "" ] || [ "$device" == "" ] || [ "$dra_size" == "" ]; then
> > +	echo "No non-sharable mem device/decoder found with DCD support"
> > +	exit 77
> > +fi
> > +
> > +if [ "$sharable_mem" == "" ]; then
> > +	echo "No sharable mem device found (mock did not stamp MOCK_DC_SHARABLE_SERIAL)"
> > +	exit 77
> > +fi
> > +
> > +# testing pre existing extents must be called first as the extents were created
> > +# by cxl-test being loaded
> > +test_pre_existing_extents
> > +test_remove_extent_under_dax_device
> > +test_create_dax_dev_spanning_two_extents
> > +test_inject_tag_support
> > +test_uuid_no_match
> > +test_uuid_no_match_seed_intact
> > +test_uuid_aggregation
> > +test_uuid_show
> > +# These two run on the sharable memdev (serial $MOCK_DC_SHARABLE_SERIAL).
> > +test_shared_extent_inject
> > +test_seq_integrity_gap
> > +test_cross_more_uniqueness
> > +test_alignment_rejection
> > +test_partial_extent_remove
> > +test_multiple_extent_remove
> > +test_destroy_region_without_extent_removal
> > +test_destroy_with_extent_and_dax
> > +test_dax_device_ops
> > +test_reject_overlapping
> > +test_two_regions
> > +test_more_bit
> > +test_driver_reload
> > +test_event_reporting
> > +
> > +modprobe -r cxl_test
> > +
> > +check_dmesg "$LINENO"
> > +
> > +exit 0
> > diff --git a/test/meson.build b/test/meson.build
> > index e0e2193..cd06bf8 100644
> > --- a/test/meson.build
> > +++ b/test/meson.build
> > @@ -171,6 +171,7 @@ cxl_translate = find_program('cxl-translate.sh')
> >  cxl_elc = find_program('cxl-elc.sh')
> >  cxl_dax_hmem = find_program('cxl-dax-hmem.sh')
> >  cxl_region_replay = find_program('cxl-region-replay.sh')
> > +cxl_dcd = find_program('cxl-dcd.sh')
> >  
> >  tests = [
> >    [ 'libndctl',               libndctl,		  'ndctl' ],
> > @@ -207,6 +208,7 @@ tests = [
> >    [ 'cxl-elc.sh',             cxl_elc,            'cxl'   ],
> >    [ 'cxl-dax-hmem.sh',        cxl_dax_hmem,       'cxl'   ],
> >    [ 'cxl-region-replay.sh',   cxl_region_replay,  'cxl'   ],
> > +  [ 'cxl-dcd.sh',             cxl_dcd,            'cxl'   ],
> >  ]
> >  
> >  if get_option('destructive').enabled()
> 
