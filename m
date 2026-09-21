Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F7F488221;
	Mon, 21 Sep 2026 23:34:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790033653; cv=none; b=kFu3BRbGM0NNq+i6Q64luwycunH23Xqpz1OvG2pxWB+tBTaFvNEdpea4iOqayz0wPpstEWBm8YPutPbneJIfFueiSgLcqZzxbuUWvsx8eT8KtLr7eDpkfifTca993kx+n6ETpDB3PR4qXXbKSVtEC05GC1KNZvfpNFyDX2Y+xmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790033653; c=relaxed/simple;
	bh=CgBfhCNxqqy/1R57Vmqx2eZ7q+Wvo+0nohHbBChlRX4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z8C8AyGodhnZ3/wzTUMABWziR1tkv2tQCwZYgpQaEfI4Cdl2JoUsU9PtYGTVv8x4+Y6OBDgNXczD1XqyMnV60k9sJo/q5bPDJ5l+/rz05QAd6iUH917ujQfRjvZv9iXJivKgyMu/qDNy0jG2LPk/CIXWvYGah6WThpz5D9JK7+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKl8hfQB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKl8hfQB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C0721F000FF;
	Mon, 21 Sep 2026 23:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790033647;
	bh=qRHgzQ7fwBcrIHPW7JscnruAs7vPiD7JEBmOX4o6mD4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=VKl8hfQBPykC27f9P+McnxIWOGPvGmgNwFW8T7YaWkeJLyLbXfkhlsb6HWZD7PK+q
	 X30goEHDTqyzyBciLI8ZQ9gmgvV5QXSFu3B+x/28iqRiaZShn+R4KwJ3BZiaQ/7gvF
	 q7M3oXQ1RAVn7cPpflHO2QXruVwEi5OSPPJ1awoWjmnSPhQ6fw6fAJgU0E3p5iIuZ7
	 phOJrWx+Fbit/qrjDInJBwM3dBqAmoBipCVc8rvzJMIl/k57oqOGPLrupqm3TzrZHK
	 woxESbPCJRHvP1+Qx9fIAaCwRg0UHCvBg3IoHnscSRayvMdXgTigFJ6Ej96b5OPZ68
	 UJ8SULgfceNWw==
Date: Tue, 22 Sep 2026 00:34:02 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Anisa Su <anisa.su887@gmail.com>
Cc: sashiko-bot@kernel.org, sashiko-reviews@lists.linux.dev,
 nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org
Subject: Re: [PATCH v12 3/8] cxl/cdat: Gather DSMAS data for DCD partitions
Message-ID: <20260922003402.5134db4a@jic23-hlaptop>
In-Reply-To: <anL0mD3DKfwJh4UY@AnisaLaptop.localdomain>
References: <20260731084901.1512819-1-anisa.su@samsung.com>
	<20260731084901.1512819-4-anisa.su@samsung.com>
	<20260731090250.0C8DE1F000E9@smtp.kernel.org>
	<20260804010748.7f9f8174@jic23-huawei>
	<anL0mD3DKfwJh4UY@AnisaLaptop.localdomain>
X-Mailer: Claws Mail 4.4.0 (GTK 3.24.52; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 5 Aug 2026 01:30:16 -0700
Anisa Su <anisa.su887@gmail.com> wrote:

> On Tue, Aug 04, 2026 at 01:07:48AM +0100, Jonathan Cameron wrote:
> > On Fri, 31 Jul 2026 09:02:49 +0000
> > sashiko-bot@kernel.org wrote:
> >   
> > > Thank you for your contribution! Sashiko AI review found 2 potential issue(s) to consider:
> > > - [Medium] The commit message claims to extract and store the 'read only' attribute from DSMAS tables, but this logic is completely missing from the code.  
> > 
> > Given it will make a lot of difference to a user if they think they have writeable
> > memory that isn't - I think we probably do want to have readonly here.
> >   
> I did some digging: it seems in v8, the read only flag was gathered and
> exposed in sysfs, but dropped during the region -> partition rework.
> 
> v8 of this commit used to do:
>     dent->read_only = dsmas->flags & ACPI_CDAT_DSMAS_READ_ONLY;
>     ...
>     mds->dc_region[i].read_only = dent->read_only;
> 
>     https://lore.kernel.org/all/20241210-dcd-type2-upstream-v8-6-812852504400@intel.com/
> 
> and a following patch exposed it, with a documented ABI:
> 
>   https://lore.kernel.org/all/20241210-dcd-type2-upstream-v8-7-812852504400@intel.com/
> 
>     /sys/bus/cxl/devices/memX/dcY/size
>     /sys/bus/cxl/devices/memX/dcY/read_only
>     /sys/bus/cxl/devices/memX/dcY/shareable
>     /sys/bus/cxl/devices/memX/dcY/qos_class
> 
> In v9 dynamic capacity moved from its own dc_region[] array and dcY/
> sysfs directory to the generic partition model:
> 
>   https://lore.kernel.org/all/20250413-dcd-type2-upstream-v9-3-1d4911a0b365@intel.com/
> 
> size and qos_class survived that move because ram and pmem already have
> them. read_only and shareable did not, because the generic partition
> model had nowhere to put attributes that only dynamic capacity has, but
> the commit message survived the rework.
> 
> More specifically, read_only was dropped from both the sysfs commit and
> this commit. shareable was dropped only from the sysfs commit, but still
> read from the DSMAS entry in v9 of this commit. Not sure why though; I
> didn't see any consumers of the attribute. Oh well... We use it now
> since shared extents are supported to check if an extent marked shared
> is actually in a shared partition.
> 
> So TLDR; I've removed the "read only" part from the commit message. But
> let me know if you think it should be re-introduced?
> 
> I agree with what you said about it being important for a user to know
> whether a partition is read only. Some things to consider:
> 
> - The partition model has no precedent for a DC only attribute.
>   dynamic_ram_1/ currently exposes size and qos_class, the same two that
>   ram/ and pmem/ expose. Adding read_only there would be the first
>   attribute that exists for one partition mode and not the others.
> 
> - shareable is in exactly the same position. It is gathered and used
>   internally but not exposed anywhere, so if we are adding one of these
>   back we should probably decide about both.

I vaguely recall the discussion on this ending up with we'd call the
partition something different to reflect the extra property.  

dynamic_readonly_1 / dynamic_sharedram_1 maybe?  Argument being
that these properties are as different from normal RAM as persistent
memory is.

> 
> - I don't think the DSMAS Flags bit 6 (read only) is specific to DCD?

In theory yes, in practice there isn't a path for non DCD to actually
get the data in place and transtion to read only so maybe an expensive
source of zeros?  So yes allowed but not much use to anyone so we
won't see it.  

>   It describes any device scoped memory range, so a read only ram or pmem
>   partition is expressible in CDAT today and the driver ignores it.
>   Maybe it should be exposed in sysfs for every partition
>   rather than only on dynamic_ram_1? Which probably makes it a generic CDAT/partition
>   patch rather than something for this series.
> 
Jonathan

