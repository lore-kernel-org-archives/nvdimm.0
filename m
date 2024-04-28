Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC54D71B39
	for <nvdimm@lists.linux.dev>; Sun, 28 Apr 2024 16:55:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714323315; cv=none; b=AP/bvz40Z63pkYMLAvaGT/6slghS7+Qd2pCiz/X0230olDylJICXq73za4v8cz9e1a3CqQev7B7uLlu3B2lesqhn/cXLwhFLeWsWHO/g2yS68LgswwPaEWa+5/tZ9fQNflGA7IffpqFyqiRa1b+1D1kUTZAQ90hCGdA2iO5o3uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714323315; c=relaxed/simple;
	bh=Ami0kmcZDld632bBgXtckLo0jbTRciV/yZarknXwkk0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cuyb3qKVFkpo/OuC1TJQjvpTUJBdkibt3MxxKLKU1YLMGtAejZN1SgvvFxEYRAliFeEHd8+EGb7jVP2uayucHoG5d2ewYiYqOu2arwpTMvFZm1bN+mqKn2kMgI28y5Y6kGlRbSjG28Cjyn3kPZwF9BjzT7SfvhhhiQ/MYtIO5iE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Wua+PkEB; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Wua+PkEB"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-6ea2f95ec67so1601795a34.2
        for <nvdimm@lists.linux.dev>; Sun, 28 Apr 2024 09:55:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1714323312; x=1714928112; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G3WwFMuHhBVtoJUHbucJSgPjjuSb7tuNIxOTsjoNK0M=;
        b=Wua+PkEBBcv/7lrpiKmgADjPeJGMtfGiXk9/4/iGKG5JQt1RFGljlYfgptfuApXORS
         zH4h3iRY0gr2bLSCJV9QnFRU8i3MXoJialJXOqT1T9hGKPQkqlNiA+CteG8cd63oIB4W
         dMg48xtrWF2gWoxaTYYvyJkcre3x7XjEsjM0waYxc00gJoLKq0ugKje8305aoIDS4lgD
         Tvo/DVYM8FW5DHajIOTClZ+zlZPBfmfX64lWyj99Ofimn7rxX+ZrtQjEQv+nytkl7wTT
         7lfOAKrXiuFc7/4Bp4/OeKI3qF18p2Il+wwqM+07PlFTZLQmnix7pKDl03EuwzdLxL3w
         HwhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714323312; x=1714928112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G3WwFMuHhBVtoJUHbucJSgPjjuSb7tuNIxOTsjoNK0M=;
        b=Tkj1+hbzYQKG2vidyhFND2XzWLm7cX4UheRh0RNiDWIXcd4B2+JpBBLPHZjNUpJxwJ
         CbuwrQpnr2Yd2E5+wAtIx8dH4pJ0+3rS0qgCFyX+4bcta48GVxQ8AQb4n2AO3G0IXxBZ
         4v1om+VlqDnjiF16VAMs8YtUEqvJ3hGoMohNpFkf+hYhfUbIaMXvTABM4nzgV1xwFvoc
         zm+dg8fNr2zNi6TqP+ceqVYwt4J5eafOSRfXAbktLBOqctiPytj2m4EKM3gDQYau/g95
         4rANvlJcLRt+XT+L5a6A/OrVWF4b8vdEhZFasgr9TVDb4MdB0O+qt661wQwLvHh0mwL8
         vF0A==
X-Forwarded-Encrypted: i=1; AJvYcCXViB6ujIOPnkH5tI9uTspVyMek8c1c+aAR/lnskAHZKMHhYD5gdcSpksLs/ZrtdzP9GGwUVsQ45OtkWbIV07dT0hSmfMYw
X-Gm-Message-State: AOJu0Yw20tuHXVPOgZd0RGKzud83LDLBmpdywXrIxQeKm4110UUneKR+
	XbOiYKL42VeUeY1jGs4hlkSAazD/hFwqVHRSq6q0UuW6yfkf5AOc
X-Google-Smtp-Source: AGHT+IFjRTjq0wJmFpd2+tz4BEbUANUM9qvQC34J+c24N/aiSVikf090UIEPVBDxgTJS8q0l820i2w==
X-Received: by 2002:a05:6870:d8cb:b0:23c:74ec:6d23 with SMTP id of11-20020a056870d8cb00b0023c74ec6d23mr1810226oac.18.1714323312541;
        Sun, 28 Apr 2024 09:55:12 -0700 (PDT)
Received: from Borg-9.local ([70.114.203.196])
        by smtp.gmail.com with ESMTPSA id wq18-20020a056871aa1200b0023c8fbe8ad8sm122537oab.47.2024.04.28.09.55.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Apr 2024 09:55:12 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Sun, 28 Apr 2024 11:55:10 -0500
From: John Groves <John@groves.net>
To: Dongsheng Yang <dongsheng.yang@easystack.cn>
Cc: Gregory Price <gregory.price@memverge.com>, 
	Dan Williams <dan.j.williams@intel.com>, axboe@kernel.dk, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org, nvdimm@lists.linux.dev
Subject: Re: [PATCH RFC 0/7] block: Introduce CBD (CXL Block Device)
Message-ID: <wold3g5ww63cwqo7rlwevqcpmlen3fl3lbtbq3qrmveoh2hale@e7carkmumnub>
References: <20240422071606.52637-1-dongsheng.yang@easystack.cn>
 <66288ac38b770_a96f294c6@dwillia2-mobl3.amr.corp.intel.com.notmuch>
 <ef34808b-d25d-c953-3407-aa833ad58e61@easystack.cn>
 <ZikhwAAIGFG0UU23@memverge.com>
 <bbf692ec-2109-baf2-aaae-7859a8315025@easystack.cn>
 <ZiuwyIVaKJq8aC6g@memverge.com>
 <98ae27ff-b01a-761d-c1c6-39911a000268@easystack.cn>
 <ZivS86BrfPHopkru@memverge.com>
 <8f373165-dd2b-906f-96da-41be9f27c208@easystack.cn>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8f373165-dd2b-906f-96da-41be9f27c208@easystack.cn>

On 24/04/28 01:47PM, Dongsheng Yang wrote:
> 
> 
> 在 2024/4/27 星期六 上午 12:14, Gregory Price 写道:
> > On Fri, Apr 26, 2024 at 10:53:43PM +0800, Dongsheng Yang wrote:
> > > 
> > > 
> > > 在 2024/4/26 星期五 下午 9:48, Gregory Price 写道:
> > > > 
> > > 
> > > In (5) of the cover letter, I mentioned that cbd addresses cache coherence
> > > at the software level:
> > > 
> > > (5) How do blkdev and backend interact through the channel?
> > > 	a) For reader side, before reading the data, if the data in this channel
> > > may be modified by the other party, then I need to flush the cache before
> > > reading to ensure that I get the latest data. For example, the blkdev needs
> > > to flush the cache before obtaining compr_head because compr_head will be
> > > updated by the backend handler.
> > > 	b) For writter side, if the written information will be read by others,
> > > then after writing, I need to flush the cache to let the other party see it
> > > immediately. For example, after blkdev submits cbd_se, it needs to update
> > > cmd_head to let the handler have a new cbd_se. Therefore, after updating
> > > cmd_head, I need to flush the cache to let the backend see it.
> > > 
> > 
> > Flushing the cache is insufficient.  All that cache flushing guarantees
> > is that the memory has left the writer's CPU cache.  There are potentially
> > many write buffers between the CPU and the actual backing media that the
> > CPU has no visibility of and cannot pierce through to force a full
> > guaranteed flush back to the media.
> > 
> > for example:
> > 
> > memcpy(some_cacheline, data, 64);
> > mfence();
> > 
> > Will not guarantee that after mfence() completes that the remote host
> > will have visibility of the data.  mfence() does not guarantee a full
> > flush back down to the device, it only guarantees it has been pushed out
> > of the CPU's cache.
> > 
> > similarly:
> > 
> > memcpy(some_cacheline, data, 64);
> > mfence();
> > memcpy(some_other_cacheline, data, 64);
> > mfence()
> > 
> > Will not guarantee that some_cacheline reaches the backing media prior
> > to some_other_cacheline, as there is no guarantee of write-ordering in
> > CXL controllers (with the exception of writes to the same cacheline).
> > 
> > So this statement:
> > 
> > > I need to flush the cache to let the other party see it immediately.
> > 
> > Is misleading.  They will not see is "immediately", they will see it
> > "eventually at some completely unknowable time in the future".
> 
> This is indeed one of the issues I wanted to discuss at the RFC stage. Thank
> you for pointing it out.
> 
> In my opinion, using "nvdimm_flush" might be one way to address this issue,
> but it seems to flush the entire nd_region, which might be too heavy.
> Moreover, it only applies to non-volatile memory.
> 
> This should be a general problem for cxl shared memory. In theory, FAMFS
> should also encounter this issue.
> 
> Gregory, John, and Dan, Any suggestion about it?
> 
> Thanx a lot
> > 
> > ~Gregory
> > 

Hi Dongsheng,

Gregory is right about the uncertainty around "clflush" operations, but
let me drill in a bit further.

Say you copy a payload into a "bucket" in a queue and then update an
index in a metadata structure; I'm thinking of the standard producer/
consumer queuing model here, with one index mutated by the producer and
the other mutated by the consumer. 

(I have not reviewed your queueing code, but you *must* be using this
model - things like linked-lists won't work in shared memory without 
shared locks/atomics.)

Normal logic says that you should clflush the payload before updating
the index, then update and clflush the index.

But we still observe in non-cache-coherent shared memory that the payload 
may become valid *after* the clflush of the queue index.

The famfs user space has a program called pcq.c, which implements a
producer/consumer queue in a pair of famfs files. The only way to 
currently guarantee a valid read of a payload is to use sequence numbers 
and checksums on payloads.  We do observe mismatches with actual shared 
memory, and the recovery is to clflush and re-read the payload from the 
client side. (Aside: These file pairs theoretically might work for CBD 
queues.)

Anoter side note: it would be super-helpful if the CPU gave us an explicit 
invalidate rather than just clflush, which will write-back before 
invalidating *if* the cache line is marked as dirty, even when software
knows this should not happen.

Note that CXL 3.1 provides a way to guarantee that stuff that should not
be written back can't be written back: read-only mappings. This one of
the features I got into the spec; using this requires CXL 3.1 DCD, and 
would require two DCD allocations (i.e. two tagged-capacity dax devices - 
one writable by the server and one by the client).

Just to make things slightly gnarlier, the MESI cache coherency protocol
allows a CPU to speculatively convert a line from exclusive to modified,
meaning it's not clear as of now whether "occasional" clean write-backs
can be avoided. Meaning those read-only mappings may be more important
than one might think. (Clean write-backs basically make it
impossible for software to manage cache coherency.)

Keep in mind that I don't think anybody has cxl 3 devices or CPUs yet, and 
shared memory is not explicitly legal in cxl 2, so there are things a cpu 
could do (or not do) in a cxl 2 environment that are not illegal because 
they should not be observable in a no-shared-memory environment.

CBD is interesting work, though for some of the reasons above I'm somewhat
skeptical of shared memory as an IPC mechanism.

Regards,
John


