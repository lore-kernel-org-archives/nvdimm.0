Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80FB33D6EA
	for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 18:20:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768155658; cv=none; b=BawsePJpppV7sj6+dZHKvX64+OfmSOxMB2JrfYkiVhu5SK0rtDPSBrxLZlbFudeio9HZnQCFHB5eBPY0BQi7Xm9Fyeo1A/6sx0dq6tqXPvAQ6f0epKyruz5fnLt/W40WY+yHL9aI7BpmLY1jwpoOzB4lpmzcO6eQyblLYMEmSPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768155658; c=relaxed/simple;
	bh=SfJrpqITJBqj4x70TkdEEHD+PTaX3wfXpnudD6F/P+c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A2mVKZNd5IUBgzPi26aoKtmMOdySxoVaOMQBDivhjFI2kilXO3kBnRijon8kMAfJV2yfzdvZ3Iu5s9bljdTeXpeU0hnUrLdEDOsP6S/ELIyKUElcEVMqD/EIOd3hbcH7Fd1HIWjvJyTzJuEVqG6gGmQUOEApvDXMpJKu+Se8jzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mQjEcdT3; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mQjEcdT3"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7cdd651c884so3445489a34.1
        for <nvdimm@lists.linux.dev>; Sun, 11 Jan 2026 10:20:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768155656; x=1768760456; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :from:to:cc:subject:date:message-id:reply-to;
        bh=aG932MlLjzhGpofJfS2a1eVc1D6C7IY/5zvR3Bf/EEg=;
        b=mQjEcdT3VUfhFZIbvKDnnE99V3YOiFkrvC1H5MC3G3sP4z0rkXLy81LRbKt9N/3fpg
         hKh/y2MPU2O+FuwX9cMI0zYjDer9j5g8mayqyVRhWnnRyoqzIy1aH0wgtlYNXzRM8Nli
         2HpQhy7ZT4MpTO038ELICdvyD05KW0ItqgnNQ4hvBSKx/Fl+sCCyN5tWQ2TfOXlblYBC
         rDdNp265PfWmq/dHgoep8dDwV6jbsnJ/f0miT8fXztcffNeyaGvOEA+EBCKiOZ2juDRj
         E8Zs3RIx6r2hg2fgxsUvKw7CLw2nnoILWAtRbXV38rHo+zHtv5XJ8AFZrdk+ERPbRLP2
         3LCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768155656; x=1768760456;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:sender
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aG932MlLjzhGpofJfS2a1eVc1D6C7IY/5zvR3Bf/EEg=;
        b=CF2EowxY4bg44/eW/GMlnpdr0kpjGaoMJZpFvScHZSUMOApSLPpcfnxa4G6scheh/c
         k0jkVGzGpdl4+D4Nu+YiuZjKG6bPbmzJJ4O73np6RIbBbZUKSFMI6zDrsgeWQs94bUqg
         lxENa+9h/q8CbVJoFHFgpUT+IF2dqs8vhWqowxmPvgVpzu3xNjjiA3Zyw3m80kaEIdlN
         kiMQuCqgOSrn/WnTVSi0q/HuJBvll2xyIIw7PDaOx9yBTBZQrveKxAMVsvNIFV3WiVnA
         0J9Gzy+itXPtbj/BdX9BQI6+LpZuMsML1A7za/cwbD9HQ+ZP6GSQq+0cZBhPw3yfzOiC
         KTEg==
X-Forwarded-Encrypted: i=1; AJvYcCUIZAWVajli7YOioOuqJjDOXB1uAEJVETt/5pRwb/rmxOzhqFueJW444MMwdSF1qVZSPjhwsiY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzGO61/YojicdXHMD3oGigrkbTqcTlrxyKAIKjzxBMVWWeJjFsJ
	An/J/qmgVaKtAr2Bv6ICkQ07xXtpoDBtk7cczwvOTrCMvuOTxBszY9nH
X-Gm-Gg: AY/fxX4lBWNLXEekkunNCvL84hyRgOao08fXC7BDJMScu63BUSaHOWofT1cWuVByNrY
	T/5vXmPKhxO/Y5TohBNHS9MmOZg3jTafOZ5ASlX/Q3AUcllT2NidjxZeFGMHYQsDoyovw0hbXoW
	eq9azwJ5jRHklHKFe/qjmp2y2w59+YKw4RdZa+i/Cx5dfDFE/7/a7XGLS8CKZYiqjK7u2H6ApYi
	O68K3DMoJtIKP+ThnLXx1W/NpeionNhi9OwI+fke5VQS2RyTzagqL7utBXeYQOeSYfV3gdyoyM6
	REMUfzALPUWRqFasNEFnV8u8nRRRLNyVx2uMi0VSG86DYzBRQmQAx8QWP1uUwHtvEAD4mQ8iLW9
	lR330skceBu1kLjYe1V0uqK9/5LNQfPjzjPkeL0CRQeP0w4TpyU5llaOEGzCmjp9YDgfaL+RzGK
	v+MonWqIFGLJ3UVu7BfP+XA519Z/zUtA==
X-Google-Smtp-Source: AGHT+IHYPDXG5/NvykQQZIk8AUunBR9mK2nY0iKcaE8B6ptLkOnehZCDGmGQeG3pX/n8s5ukcPG3LA==
X-Received: by 2002:a9d:538d:0:b0:7c7:e3b:4860 with SMTP id 46e09a7af769-7ce50b7a52cmr6541341a34.10.1768155655722;
        Sun, 11 Jan 2026 10:20:55 -0800 (PST)
Received: from groves.net ([2603:8080:1500:3d89:cc0c:a1b0:fd82:1d57])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfb21a150asm911499a34.31.2026.01.11.10.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Jan 2026 10:20:55 -0800 (PST)
Sender: John Groves <grovesaustin@gmail.com>
Date: Sun, 11 Jan 2026 12:20:52 -0600
From: John Groves <John@groves.net>
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	Alison Schofield <alison.schofield@intel.com>, John Groves <jgroves@micron.com>, 
	Jonathan Corbet <corbet@lwn.net>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, David Hildenbrand <david@kernel.org>, 
	Christian Brauner <brauner@kernel.org>, "Darrick J . Wong" <djwong@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Josef Bacik <josef@toxicpanda.com>, 
	Bagas Sanjaya <bagasdotme@gmail.com>, Chen Linxuan <chenlinxuan@uniontech.com>, 
	James Morse <james.morse@arm.com>, Fuad Tabba <tabba@google.com>, 
	Sean Christopherson <seanjc@google.com>, Shivank Garg <shivankg@amd.com>, 
	Ackerley Tng <ackerleytng@google.com>, Gregory Price <gourry@gourry.net>, 
	Aravind Ramesh <arramesh@micron.com>, Ajay Joshi <ajayjoshi@micron.com>, venkataravis@micron.com, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH V3 13/21] famfs_fuse: Famfs mount opt: -o
 shadow=<shadowpath>
Message-ID: <fcwsytw5kd44veyzfel3uxwk2xsi4ywcy354s7rwaj7v4okwf7@ou4nmbo6eixo>
References: <20260107153244.64703-1-john@groves.net>
 <20260107153332.64727-1-john@groves.net>
 <20260107153332.64727-14-john@groves.net>
 <CAJnrk1bJ3VbZCYJet1eDPy0V=_3cPxz6kDbgcxwtirk2yA9P0w@mail.gmail.com>
 <zcnuiwujbnme46nwhvlwk7bosvd4r7wzkxcf6zsxoyo6edolf7@ufqfutxq4fcp>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <zcnuiwujbnme46nwhvlwk7bosvd4r7wzkxcf6zsxoyo6edolf7@ufqfutxq4fcp>

On 26/01/09 06:38PM, John Groves wrote:
> On 26/01/09 11:22AM, Joanne Koong wrote:
> > On Wed, Jan 7, 2026 at 7:34 AM John Groves <John@groves.net> wrote:
> > >
> > > The shadow path is a (usually in tmpfs) file system area used by the
> > > famfs user space to communicate with the famfs fuse server. There is a
> > > minor dilemma that the user space tools must be able to resolve from a
> > > mount point path to a shadow path. Passing in the 'shadow=<path>'
> > > argument at mount time causes the shadow path to be exposed via
> > > /proc/mounts, Solving this dilemma. The shadow path is not otherwise
> > > used in the kernel.
> > 
> > Instead of using mount options to pass the userspace metadata, could
> > /sys/fs be used instead? The client is able to get the connection id
> > by stat-ing the famfs mount path. There could be a
> > /sys/fs/fuse/connections/{id}/metadata file that the server fills out
> > with whatever metadata needs to be read by the client. Having
> > something like this would be useful to non-famfs servers as well.
> 
> The shadow option isn't the only possible way to get what famfs needs,
> but I do like it - I find it to be an elegant solution to the problem.
> 
> What's the problem? Well, for that you need to know some implementation 
> details of the famfs userspace. For the *structure* of a mounted file 
> system, famfs is very passthrough-like. The structure that is being 
> passed through is the shadow file system, which is an actual file system 
> (usually tmpfs).  Directories are just directories, but shadow files 
> contain yaml that describes the file-to-dax map of the *actual* file. 
> On lookup, the famfs fuse server (famfs_fused), rather than stat the 
> file like passthrough, reads the yaml and decodes the stat and fmap info 
> from that.
> 
> One other detail. The shadow path must be known or created (usually
> as a tmpdir, to guarantee it starts empty) at mount time. The kernel
> knows about it through "-o shadow=<path>", but otherwise doesn't use
> it. The famfs fuse server receives the path as an input from 
> 'famfs mount'. The problem is that pretty much every famfs-related
> user space command needs the shadow path.
> 
> In fact the the structure of the mounted file system is at 
> <shadow_path>/root.  Also located in <shadow path> (above ./root) is a 
> unix domain socket for REST communication with famfs_fused. We have 
> plans for other files at <shadow path> and above ./root (mount-specific 
> config options, for example).
> 
> Playing the famfs metadata log requires finding the shadow path,
> parsing the log, and creating (or potentially modifying) shadow files
> in the shadow path for the mount.
> 
> So to communicate with the fuse server we parse the shadow path from
> /proc/mounts and that finds the <shadow_path>/socket that can be used
> to communicate with famfs_fused. And we can play the metadata log
> (accessed via MPT/.meta/.log) to <shadow_path>/root/...
> 
> Having something in sysfs would be fine, but unless we pass it into
> the kernel somehow (hey, like -o shadow=<shadow path>), the kernel
> won't know it and can't reveal it.
> 
> A big no-go, I think, is trying to parse the shadow path from the
> famfs fuse server via 'ps -ef' or 'ps -ax'. The famfs cli etc. might
> be running in a container that doesn't have access to that.
> 
> Happy to discuss further...

After all that blather (from me), I've been thinking about resolving
mount points to shadow paths, and I came to the realization that it's
actually easy to enable retrieving the shadow path from the fuse
server as an extended attribute.

I implemented that this morning, and it appears to be passing all tests.
So I anticipate that I'll be able to drop this patch from the series
when I send V4 - which should be in the next few days unless discussion
heats up in the mean time.

Thinking back... when I implemented the '-o shadow=<path>' thingy
more than a year ago, I still had a *lot* of unsolved problems to 
tackle. Once I had "a solution" I moved on - but the xattr idea looks
solid to me (though if anybody can point out flaws, I'd appreciate it).

(there's an Alice's Restaurant joke in there somewhere if you squint,
about not having to take out the garbage for a long time, but probably 
only for old people like me...)

Regards,
John

[ ... ]

