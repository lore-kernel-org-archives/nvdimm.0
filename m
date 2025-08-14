Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A918A318148
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 10:37:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755167842; cv=none; b=qbDWfO8kdpN3U5apdv95Uiq7Kgbrqy5xLUaf8eWuucCIZjIRj6RL1E0U8G4AT2u5QvTks9JVymr22GlYBbvHsI3Q5bAsP61sjddTDkjeXrJUqguyRySVLY9GEPwwLqU/sGMT+yIBzY+IxcsIuwesSXjw/4nq0zz+YXgxkv1kciw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755167842; c=relaxed/simple;
	bh=2z4KHp3G9a5b9AfVC4TLzGl8oU7ja1D8uVs4f94B57E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CjgRpUh6b2L1+LqQx3/xHtcBZ4oDomp71bPSjNhrCv8oLiwRw6ScCaK1vmKRycMTkZ/rr30FvL5RFMRrei5gD8Y/2IWQqi3/6Lp87xE+ITdLRIODp00RCbz2bZO7CGKhCdUB+s+IUJv03oZpuciXTzl0PP5wCWZTVd75UUxItQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=QJbk3fgq; arc=none smtp.client-ip=209.85.222.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="QJbk3fgq"
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-7e870325db1so71013885a.0
        for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 03:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1755167839; x=1755772639; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kfg1xdeLOfyreKnr328hQaYYjz2z+mng0dgiwOWK8Ho=;
        b=QJbk3fgqiiq8hkk3mq5ra0+RetPhxZJPsFiBxPTsZe4G9rIUKE84/0UUxiIaplqrjR
         jMOzb2m2BUROqXfhiHYV5bajZX28PdqeUoq5fU4ZQva3Iz8XI+voPhSyY9XRKS3T0XcK
         IdLI+WQoouRqJYp8D6xO378t4QA4InJ8ag8UQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755167839; x=1755772639;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kfg1xdeLOfyreKnr328hQaYYjz2z+mng0dgiwOWK8Ho=;
        b=EOTtz7P1BEv907dkIGofwQfUi5A9nDOrY+HDW1tSDeWgE2C4tYyt9DQ8kciunG0XG2
         edVMOmIjmDdxA+TLl8OEMbOmoPqWgpbNr0csJVGQ6hxtN2w2Xiiuxa7icah9pXMkWARq
         gy7ntMUnce7triH2MMKxY6kkJ51XF0bhSfz8xtQDthHvQg181T8/Lh4tiyTSQQTqY9Mh
         gRCMPs79nxcocuDbQXiy22zA5sxb69r93M4zIdGBZ4HFR+Ngu99bpahwjQtT/3LxK+XB
         0w7CA3T04suGwHuGqQp63qahyMVifC6hf5yu0pQmn/7bNU7EiHjSttPPbO7t+Co0pKVz
         yN5w==
X-Forwarded-Encrypted: i=1; AJvYcCWVFUHFBocKylTNlm2uMUU/6vvwGl+bjd8L6QvRIIXAqGl67NWqNEv+T9GsdJvw6BNM7Vxgtlo=@lists.linux.dev
X-Gm-Message-State: AOJu0YwIj5rngEusmWRKg6hUBxRKMstgJ+K84O27JD9tZKhvKURtKUPV
	AT2j1m5IjirzUMjQ9JbNaHvd3xUSg72QyzaZjdc1qPOX3oZrkqagP1mJpgLlgyT4T7OBs0SyCyh
	m51U2q/T8pnWucIUFIDN4ykKAzNwSwwRd2thkbjQ75A==
X-Gm-Gg: ASbGncspUmw9JHiRdyE0Y+SfkTemqvL78Ynfm0lQJELb50RW0xMKV1Bx2vFVcwk6Fdq
	mEeHldF3Y8AQNPi5f79WfmYKR4p047dyMraeKYkUHm//ksU0dC0uQBeyw9wreRUGQwDOSl9kusa
	rHvx/vzJIqsUn6xYYEK4TVGbQJdks/FQ2q2ehQOBW9hyTEv8hjM5QifwB1ax7kk/Nt1S30XTBct
	ovZ
X-Google-Smtp-Source: AGHT+IGCyQ+LrtnuvvD4cnfS9KWxmodF+LtsJHdOQQ03BWq4ghzPdSAt/rs4hdQANvXyGJmp0NayklHjGgL6sn9UaHM=
X-Received: by 2002:a05:620a:17a8:b0:7e7:f84c:9d65 with SMTP id
 af79cd13be357-7e87066e73cmr321505585a.38.1755167839208; Thu, 14 Aug 2025
 03:37:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703185032.46568-1-john@groves.net> <20250703185032.46568-12-john@groves.net>
 <20250709035911.GE2672029@frogsfrogsfrogs> <ttjh3gqk3fmykwrb7dg6xaqhkpxk7g773fkvuzvbdlefimpseg@l5ermgxixeen>
 <20250712055405.GK2672029@frogsfrogsfrogs>
In-Reply-To: <20250712055405.GK2672029@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Aug 2025 12:37:08 +0200
X-Gm-Features: Ac12FXw_tUJvAdswzhdrUe0cP4gCxZqTC0WTTpEt7BoMabiUDl0tjdFveoca6_Y
Message-ID: <CAJfpegspQYVbWVztU5_XFwbGaTQKe2NCm2mcui6J3qv1VDxdSQ@mail.gmail.com>
Subject: Re: [RFC V2 11/18] famfs_fuse: Basic famfs mount opts
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: John Groves <John@groves.net>, Dan Williams <dan.j.williams@intel.com>, 
	Bernd Schubert <bschubert@ddn.com>, John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, 12 Jul 2025 at 07:54, Darrick J. Wong <djwong@kernel.org> wrote:
>
> On Fri, Jul 11, 2025 at 10:28:20AM -0500, John Groves wrote:

> >     famfs_fuse: Basic famfs mount opt: -o shadow=<shadowpath>
> >
> >     The shadow path is a (usually tmpfs) file system area used by the famfs
> >     user space to commuicate with the famfs fuse server. There is a minor
> >     dilemma that the user space tools must be able to resolve from a mount
> >     point path to a shadow path. The shadow path is exposed via /proc/mounts,
> >     but otherwise not used by the kernel. User space gets the shadow path
> >     from /proc/mounts...

Don't know if we want to go that way.  Is there no other way?

But if we do, at least do it in a generic way.  I.e. fuse server can
tell the kernel to display options A, B and C in /proc/mounts.

Thanks,
Miklos
