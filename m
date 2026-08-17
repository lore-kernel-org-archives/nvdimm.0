Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90AF544C660
	for <nvdimm@lists.linux.dev>; Mon, 17 Aug 2026 16:19:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786983598; cv=none; b=kzbz8ULiq9qtx9XTWOaguhUobm4+x/rupGpdjddIdOzbuPis0kN7Qa4/0kCak/LHspZiyATcgaSy+6kUATN5aqnEAwl8CGgvRh/vcTRWg4LzK+odAYUQRxh/BA9fvZqORxtUfaQaOcgsblgp4jHWljcsHlMorYa9lyYhTHu7vHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786983598; c=relaxed/simple;
	bh=nz9452HQkCizulHzHgH6sPXgLsUkaADhbih6+tFp8A8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bPKmWZzOqm/wsTKmxVvKpDjBIc2qMAEGJHz8Mwv99UXpyi3ZsVoNDBwK9PZzGh73NP2fqf4p6Sk1iKHz48FOz1GjiXXNcz15OLW6b1kvqxkitaKiRrhQkanu0vbRxYd+7JsTyQKlKcEFwomXsvc4P7gN0FukPL7Cf3woJh0pLK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net; spf=pass smtp.mailfrom=gourry.net; dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b=AEUqJZ+i; arc=none smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gourry.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gourry.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.b="AEUqJZ+i"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e7632b193so224794985a.2
        for <nvdimm@lists.linux.dev>; Mon, 17 Aug 2026 09:19:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1786983593; x=1787588393; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=g79rp1EAN8LS02s21Qd/CfSeDeEXT49xOteHy0W5fBY=;
        b=AEUqJZ+i6D7Izl6EUO4a0alOadQYJi1sfUTEfW5gTDi4jYYtJz4pKIupPd7iodaJEj
         pFIDR9XqY6821CtdpiJKFfMCBb8/pEtIq3SkDe2LAh4qxC8w8fFVPjvWymA77Ltj7EE3
         IummCcjl4FFxyfGtAjGun9htdLjJTD7lWTxspO7sieCq5MpShPoPttJQWdK+iZHl9acV
         WCUvdhBOOga+TJcJwufyHSn4MpGh30+PS41K8KpU8G4o0sXvqIYWtFZ5Ni92qOMGu7sG
         5GIUYH+HxH8vKwsqk5LZkMqLWJ91jJeCfahji+s1AYuYQp5dUSyDtvBzHQ/Vu8/Rls6f
         bQUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786983593; x=1787588393;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g79rp1EAN8LS02s21Qd/CfSeDeEXT49xOteHy0W5fBY=;
        b=JQn5ctaxL25Baw4txehcLrZrPYiirA07WOLIxk8YTDuUwB32PRlsYy81w1Di8C0Rdq
         C78VxG7mqjMc0LP0LS04Lpp6nl9VyNasu7ObPDHSXQFDe09ar5FA8nUPuWkJb6RECBAK
         LGbF6ile1ljhLUpotK9tcNjAa8eGw2vsbAodDf7QtBpyxuZGs4XY2XbYLFahAgQ/Rv1T
         jrurOypvClkuIbgRbTLFBfwjyWj8U10j4CQ+AxvBWUe25ngcnUHzudmCodok63kYp1AU
         pB8ioeFiQfkkLAh9ikyl2wzz0pqNq+5JU1bGV2bPjEvgnPFu3uJ5ZaCNPFPektcZ/Vzy
         fwmg==
X-Forwarded-Encrypted: i=1; AHgh+Rpv/8HRrcSRvb6Xid62DNrj+KW9zmOV4C0LUtq1w3UbjeyIVxJ4lkJSaydaqc4Ipw/WMklrmnA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwWGiJg8aIR+jO1OKjzVBg8izsneHEYi0xd1XKlvJlxTZRV1XzF
	rB/zbBbcXOiKeKHmiilVUeJKZIibN8YUALby+35SHz70Wos6BiSFAv019TogZu/EQ/Q=
X-Gm-Gg: AR+sD10+LgsYyHgi5CLX+Ks4lK/TYlI0H2JlWthoAe80OJ2yfVyY5HO0jGQ5wwSn+Oe
	kS5LIfRQ0guNo/IycuEXPGcPATRbE+AxX6joZNKfVYxVA0PLobm3AbfVdhc8Nsie3Kbkz91UDVC
	GwVFsvg8AlTutQ2VncrC3TzNnh7NkGofOKvSuLzlKk4k5LdGjj+Q1n5RPGuiy20GUqfWWm4vfYC
	h39N/Vef8vElorv64w6vYRZwEk4jWpbU0quIp/aG9xSXogvP8PFqeruC9SMt0n7zZdKC/os9XZs
	5Ex3JxBZd+kK2KF8raLWhGjzyF4x5bnBCqbx2xptT7yayOpWnJYL5YjhrB2co4IJifGrLUv8HNb
	X3q3tA8axd/Qu+m81xZhzxgcfEqgtnhnx8GdkJIKKtWjUAE8WBtTY5QerTn9Vo6SRXrqkoLWZIo
	LcwbiPGxvVkpxzMdBtwP3Argv9lwtY1ObQoRYmnKn/GiuvdcvyG2O7uRtAVi1Xx82Nh4Ksw36kw
	3UDlB2DpphukFaBStka5hbctp30+IBTESWuNmCRY5vG
X-Received: by 2002:a05:620a:5302:b0:936:ce17:dac3 with SMTP id af79cd13be357-936d238d066mr2289883285a.40.1786983593483;
        Mon, 17 Aug 2026 09:19:53 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-937033ce78csm80835485a.31.2026.08.17.09.19.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 09:19:53 -0700 (PDT)
Date: Mon, 17 Aug 2026 12:19:51 -0400
From: Gregory Price <gourry@gourry.net>
To: Rakie Kim <rakie.kim@sk.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev, 
	ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com, 
	byungchul@sk.com, ying.huang@linux.alibaba.com, apopple@nvidia.com, 
	david@kernel.org, ljs@kernel.org, liam@infradead.org, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, dave@stgolabs.net, 
	jic23@kernel.org, dave.jiang@intel.com, alison.schofield@intel.com, 
	vishal.l.verma@intel.com, ira.weiny@intel.com, harry@kernel.org, kernel_team@skhynix.com, 
	honggyu.kim@sk.com, yunjeong.mun@sk.com
Subject: Re: [PATCH 0/4] mm/mempolicy: introduce package-aware weighted
 interleave
Message-ID: <aoMv3OhqkBTzSfek@gourry-fedora-PF4VCD3F>
References: <20260806080936.421-1-rakie.kim@sk.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806080936.421-1-rakie.kim@sk.com>

On Thu, Aug 06, 2026 at 05:09:31PM +0900, Rakie Kim wrote:
> 
> To make this possible the kernel needs a notion of which nodes share a
> package. The NUMA distance model offers only relative latencies and no
> structural grouping, which is especially limiting for CXL memory nodes
> that come online without an explicit package association.
> 

The original attempt to handle cross-socket interleave tried to deal
with this with a matrix for weights, but this was deemed too invasive.

This brings back that matrix, but not for per-node weights - we're
basically just adding an addition weighting to filter on.

I have some concerns with the now additional filtering mechanism
introdced into the allocation stack, but fundamentally I think this is 
a *better* solution than a straight weight-matrix.

I will need to chew on this for a bit.  It seems there's non-trivial
sashiko bug reports here to address anyway.

> The series adds a package-aware topology layer that groups CPU and
> memory-only nodes into a "memory package", built from the physical
> package ids firmware reports and, for a memory-only node, an initiator
> CPU node or SLIT distances. A package can contain more than one CPU node
> or more than one memory-only node, so the layer maps a package to a set
> of nodes rather than to a single node or a single CXL device.
> 

When worded this way, "Package" sounds completely arbitrary and not a
useful distinction.  This really just sounds like an extention for the
existing fallback lists to take interconnects into account.

I wonder if abstract distance either:
  1) already gives you what you want (the secondary weight)
  2) can be twiddled in BIOS to give you what you want.

> The feature is off by default and opt-in through a sysfs toggle. The
> package topology itself is exposed read-only under
> /sys/devices/system/package/; there is deliberately no writable
> override, since a machine whose firmware describes its topology
> incorrectly should be fixed in firmware. On a topology that does not
> have the symmetric shape the placement relies on, enabling is refused
> and any active mode degrades cleanly to the original flat behavior.

The way this is written it sounds to me like this should just be the
default weighted interleave behavior.  We already know weighted
interleave does not jive well with multi-socket systems - this just
fixes that (in a more general sense, Socket => Package).

~Gregory
