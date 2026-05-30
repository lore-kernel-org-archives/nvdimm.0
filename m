Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CED33225775
	for <nvdimm@lists.linux.dev>; Sat, 30 May 2026 13:06:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=216.40.44.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780146390; cv=none; b=baMqfi51PqCFN9CHjWlkQtfe3hmUb6df9kCURt9RIpHkwIUw01oty5X4k45DOpToGEZ8uTd1hONfxIQm3RzsXFnCttBoKDWDzIUjF1HB7+K6y7WSIBgiQ8MUAAeHQ+lhImDlvp5Kl1IoA8lxIy+NnZAU6q3oyBOYSMyUg9x4HYE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780146390; c=relaxed/simple;
	bh=2ABZHv73MowCHL57OPh+YjN8tPSPSEAHFPnRCGObCEI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=o0oJI3pw2Ltf/Qq2V/3OkiQfzFt3rJey8zVGKaHwAnYIXxA28xDXF5JvZu1/ev2aO4JqT6DW40aZdaDd9G8VoxkArw91xYhxigZcNy/KfQFEq1med6ciljtMKE+KN4jOuibpETfSZdt6/eM72zQGfDZR360Dnm97I2L4pdfsb98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=groves.net; arc=none smtp.client-ip=216.40.44.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=groves.net
Received: from omf19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5072B1613B1;
	Sat, 30 May 2026 13:06:26 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: john@groves.net) by omf19.hostedemail.com (Postfix) with ESMTPA id 69E8920029;
	Sat, 30 May 2026 13:06:22 +0000 (UTC)
Date: Sat, 30 May 2026 08:06:21 -0500
From: John Groves <John@groves.net>
To: Dave Jiang <dave.jiang@intel.com>
Cc: John Groves <john@jagalactic.com>, Dan Williams <djbw@kernel.org>, 
	John Groves <jgroves@micron.com>, Vishal Verma <vishal.l.verma@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Miklos Szeredi <miklos@szeredi.hu>, Alison Schofield <alison.schofield@intel.com>, 
	Ira Weiny <iweiny@kernel.org>, Jonathan Cameron <jic23@kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, "linux-cxl@vger.kernel.org" <linux-cxl@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH V2 4/7] dax/fsdev: clamp direct_access return to current
 physical range
Message-ID: <ahrfpRtpeZKKZPyG@groves.net>
References: <0100019e511fb82e-1a444df3-8310-40ed-8380-72e1373d5da9-000000@email.amazonses.com>
 <20260522191907.79187-1-john@jagalactic.com>
 <0100019e51209df4-90c4ba85-6cc5-4f5d-af26-451e7e786535-000000@email.amazonses.com>
 <16628b9f-a624-46f8-8a7f-3b9e7963963b@intel.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <16628b9f-a624-46f8-8a7f-3b9e7963963b@intel.com>
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 69E8920029
X-Stat-Signature: kc4k66ndgjuifzsaj64b84giuqsi6n1s
X-Session-Marker: 6A6F686E4067726F7665732E6E6574
X-Session-ID: U2FsdGVkX198LYxhY3/aOaSmNYak0fUivv4r0QL3LRU=
X-HE-Tag: 1780146382-404624
X-HE-Meta: U2FsdGVkX18FsthJhXJNuQ8DcAFt16fMeIwFty4TgNw62RUJS8FxCFa5AChJUtUwEyiF6eEKJ/I3e4NRRHYEDrYaG9hrx5kgS9RpqMfljeaswaq5eZORqs2NNuVYMwbXAHgy+5/CISdlDpnZ9bJhNYwdddew5gKY9EmH6KZWvUBfBTGt3aQ7/4D6dYF2aJ+7Me8ini0uFkMW3DTZRH2KFdozkbDOWsSWtbmE/uHGIfVNkyzXi6BhEjn20Q3dGVYYbFH1KZUN9x3Yb6EYMcMhogYYEauO+QddapNq6QRitZ7QIo1OPOByDPm3PJ5vjVseIu1voZDtKgCBuilcrnOUuoTXicIEFAey6h7SUgsrXVl7eMQr1mRDOKMFpvNGJsmAtkh8zfYGxSQiQSLygRYoPw==

On 26/05/26 05:00PM, Dave Jiang wrote:
> 
> 
> On 5/22/26 12:19 PM, John Groves wrote:
> > From: John Groves <John@Groves.net>
> > 
> > __fsdev_dax_direct_access() returned the number of available pages based
> > on cached_size (the total size across all ranges). For multi-range
> > devices with physical gaps between ranges, this over-reports the number
> > of physically contiguous pages available from the returned kaddr/pfn.
> > Callers trust this return value to mean contiguous pages, so accessing
> > beyond the current range boundary would hit unmapped or unrelated memory.
> > 
> > Fix by finding the range that contains the translated physical address
> > and clamping the return to the remaining pages within that range.
> > 
> > Also remove the now-unused cached_size field from struct dev_dax, since
> > it was only consumed by the old return calculation.
> > 
> > Fixes: 099c81a1f0ab3 ("dax: Add dax_operations for use by fs-dax on fsdev dax")
> > Signed-off-by: John Groves <john@groves.net>
> 
> I ran this through Claude and this is what it came back with and it looks reasonable to me:
> 
> The claimed bug does not manifest in the current tree. This is a
>   refactor + dead-field removal dressed as a bugfix. Either the justification is
>    wrong or there's a missing companion change.
> 
>   The claim doesn't hold up
> 
>   Commit message:
> 
>   ▎ __fsdev_dax_direct_access() returned the number of available pages based on
>   ▎ cached_size (the total size across all ranges). For multi-range devices with
>   ▎  physical gaps between ranges, this over-reports the number of physically
>   ▎ contiguous pages available from the returned kaddr/pfn.
> 
>   Walk through it. __fsdev_dax_direct_access does:
> 
>   phys = dax_pgoff_to_phys(dev_dax, pgoff, size);
>   if (phys == -1)
>       return -EFAULT;
>   ...
>   return PHYS_PFN(min(size, dev_dax->cached_size - offset));
> 
>   Now look at what dax_pgoff_to_phys (drivers/dax/bus.c:1433) enforces:
> 
>   phys = PFN_PHYS(pgoff - dax_range->pgoff) + range->start;
>   if (phys + size - 1 <= range->end)
>       return phys;
>   break;        /* falls through to return -1 */
> 
>   It returns valid phys only when the entire requested size fits inside a single
>    range. If the request straddles a gap, it returns -1 and the caller bails
>   with -EFAULT before ever reaching the clamp.
> 
>   So in the only path where the clamp runs, we already know size <= range->end -
>    phys + 1, which means cached_size - offset >= size, which means min(size,
>   cached_size - offset) == size. Pre-patch returns nr_pages. Post-patch returns
>   nr_pages. Same answer.
> 
>   I worked it through with concrete numbers on a 2-range device with a physical
>   gap (range[0]=4 pages at 0x1000_0000, range[1]=4 pages at 0x2000_0000):
>   - pgoff=2, nr_pages=2: both return 2. ✓
>   - pgoff=3, nr_pages=2 (straddles gap): both return -EFAULT via the early bail.
>    ✓
>   - pgoff=4, nr_pages=2: both return 2. ✓
> 
>   I cannot construct a case where pre-patch over-reports.
> 
>   What's actually changed
> 
>   1. A no-op clamp loop replaces a constant calculation. Same return value in
>   every reachable case.
>   2. The trailing return -EFAULT; is dead code. If dax_pgoff_to_phys returned
>   valid phys, then by construction phys lies inside some range in
>   dev_dax->ranges[], so the loop will match.
>   3. O(N) walk replaces O(1) arithmetic. Trivial for small nr_range, but it's a
>   regression in the wrong direction for a hot path.
>   4. cached_size field is removed. Good cleanup — I grepped, no other consumers.
> 
> 
> DJ

Thanks Dave. Sashiko reviews can be great, but sometimes they make us (me)
dumber. 

Dropping this patch from the series.

John

<snip>

