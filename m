Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFD532143C
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 14:39:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755182352; cv=none; b=OSmldG0RL6k4eb0JUUh7lFVb+hNiDmAZ4PrczFzjjDvcIpNdosTKmYJEaDN5QdWzyRfYkqQ7nMqWxQZheo4kTZqVC/WzvyOYJHP682JrvIAvJot82strYEeL1R+m9JJ/7bpjmGj4PrdbOAK+/orw0XR0XpZG66hJtRapQFjbcMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755182352; c=relaxed/simple;
	bh=AnC/DqN/3+QD8sNj2gcFRZg+yXdHvLgwCqX9lbwEcDc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SGTCCyBnh603O9aTaolWo3yvOCJunmc9p7xQp6BeFmc8X6x3fG0kXru4WyXhZWtQQjsShEmhMCL6vzN4lMB+49QSTdUhoTy0ck9kt/3KzjJGC8VxCuQ8DDGPel5Brx/4JkDwAhDpRxtJeojFDrSJKUJDHw77WWOm2v5f1gll9O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=U1LHDHhS; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=groves.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="U1LHDHhS"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-30cce923bc2so495799fac.1
        for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 07:39:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755182350; x=1755787150; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iWpyQA5QJOFGfrytZDcocu1YuU1IqW03ExZyqZsW3CI=;
        b=U1LHDHhSpcvk6NlqbHj5jGXw2UM3N3k5VKq2kV1M0duMQ5aFVGcI7DIjk9Eub2vJZJ
         EwawvAosAMCOnzfc66exwkUIlGE4h3RgrU+FusTnslrLaygURmOwQYfn3YJmOhPZk1g8
         TdzrliXr920KrBW9+S/cbZCgtQt6erM8YztnEp9tmUiqlVXqHo/Yi9aAwn9/ioFdYiPt
         5ompVjVCLBIxHEBk5hfG+22lRFNTrzpwTdhUCgIv9I9JpYO4XOB2RTZKRrKfJ/+laUfB
         EPA/ZybPpXTzLH4u0MtrD+UbNhTSAyB9fxHGTSzpyvZm6GpqxmjOno06vmRLcJ1oNFrm
         uZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755182350; x=1755787150;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iWpyQA5QJOFGfrytZDcocu1YuU1IqW03ExZyqZsW3CI=;
        b=wshf7c9ytmDCLRMgLggBexRAvgW6U3KJ73hejRXggNhy0KJvTNmzmP2qKis6ebVEpm
         TbWlbJzSu6g3tSuy35fuv/IvBO29O9pNcQBYyUM+vm+wVNlWr7nqc3hhQRCktQ4eHLTs
         80Ish6UOkwus2Jy5+4aDrzFITGm1GYMVX5AEyAsUkzSDv3D1wGgfFjkxoyscGPTGdUz+
         8SA+b3eI2R5Ta0Cu1J3QyCn9YGYT/7qPdTnbNbJ4t49wLofi/F15ayUBtNoHgA5ypQtS
         ksfW7b0uqnNCSDwxvADoScM6axgAJ5OTVWefF6qRleV8S+V8IEefuyJQqryiiblYzCzQ
         En7A==
X-Forwarded-Encrypted: i=1; AJvYcCUBN5f9L+bY9g9KX/cQnSiKOnH8P6AVBq+FNzl/+yif/bEg3AZWOlmP3JPJE681sm+6q5rQ9Ew=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrgDf3KqqzIKf9E/cj0vAQZG14h8VNCHfjAl0DzJKSDeMvUIk0
	8l4v5k7dFdtlUKE9nK5K3FZY43T7CvTX0iUZuD7xI6RRprqR5Gd/eK5N
X-Gm-Gg: ASbGncuVvH5lrKnp0NWVDvwrohywrgkljcRa6O3Pn3GwfDzRm6G42CWTlmdUb9ezkmf
	Xn9aWeIjbMZCGVz6xhacrTQkxO91mvNKgx4pD6UxkSfihFRfhh11D6l7dXBjlSQuZ0yOkF1Fmcj
	S+1aGwJsdWUN2h9nKSzQzQQX/LkUs9TduipdufKT4GiLzRaw2eSmLiVjv2Khfcawf/fdGaXUJ3r
	b/EV9o8nJ9buo+AqyA/TMrOe8pO42wQrLvx6Y39zkIZoVGx2/3ozjGB9RgY/+4RJ+9zhmfpx9Ci
	XRmYfiy1N6emAYVSXk5Jj12Lgt+4YVsfJBAgxNwd9+FNS5djGjlNmQ0GRwD3vqBRX6qm/yUdK9H
	v7F+wXOUaSG5UZYfOd5xmm1cTfrW299NJVGg=
X-Google-Smtp-Source: AGHT+IG/0DykLtw0r1gxLmo0cOZgYGY+cYP6P2+OvSN7+o24BGSh9UPK1E6zyX60n1GNyXlKeGrCwA==
X-Received: by 2002:a05:6871:283:b0:30b:9a99:8d67 with SMTP id 586e51a60fabf-30cd12ea93dmr2086335fac.22.1755182349763;
        Thu, 14 Aug 2025 07:39:09 -0700 (PDT)
Received: from groves.net ([2603:8080:1500:3d89:c402:c230:52f:252c])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-30ccfe57152sm687204fac.10.2025.08.14.07.39.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 07:39:09 -0700 (PDT)
Sender: John Groves <grovesaustin@gmail.com>
Date: Thu, 14 Aug 2025 09:39:07 -0500
From: John Groves <John@groves.net>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, 
	Dan Williams <dan.j.williams@intel.com>, Bernd Schubert <bschubert@ddn.com>, 
	John Groves <jgroves@micron.com>, Jonathan Corbet <corbet@lwn.net>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Jeff Layton <jlayton@kernel.org>, 
	Kent Overstreet <kent.overstreet@linux.dev>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	Amir Goldstein <amir73il@gmail.com>, Jonathan Cameron <Jonathan.Cameron@huawei.com>, 
	Stefan Hajnoczi <shajnocz@redhat.com>, Joanne Koong <joannelkoong@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, Aravind Ramesh <arramesh@micron.com>, 
	Ajay Joshi <ajayjoshi@micron.com>
Subject: Re: [RFC V2 11/18] famfs_fuse: Basic famfs mount opts
Message-ID: <z56yzi6y4hbbvcwpqzysbmztdhgsuqavjbnhsjxp3iumzvvywv@ymudodg3mb5x>
References: <20250703185032.46568-1-john@groves.net>
 <20250703185032.46568-12-john@groves.net>
 <20250709035911.GE2672029@frogsfrogsfrogs>
 <ttjh3gqk3fmykwrb7dg6xaqhkpxk7g773fkvuzvbdlefimpseg@l5ermgxixeen>
 <20250712055405.GK2672029@frogsfrogsfrogs>
 <CAJfpegspQYVbWVztU5_XFwbGaTQKe2NCm2mcui6J3qv1VDxdSQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegspQYVbWVztU5_XFwbGaTQKe2NCm2mcui6J3qv1VDxdSQ@mail.gmail.com>

On 25/08/14 12:37PM, Miklos Szeredi wrote:
> On Sat, 12 Jul 2025 at 07:54, Darrick J. Wong <djwong@kernel.org> wrote:
> >
> > On Fri, Jul 11, 2025 at 10:28:20AM -0500, John Groves wrote:
> 
> > >     famfs_fuse: Basic famfs mount opt: -o shadow=<shadowpath>
> > >
> > >     The shadow path is a (usually tmpfs) file system area used by the famfs
> > >     user space to commuicate with the famfs fuse server. There is a minor
> > >     dilemma that the user space tools must be able to resolve from a mount
> > >     point path to a shadow path. The shadow path is exposed via /proc/mounts,
> > >     but otherwise not used by the kernel. User space gets the shadow path
> > >     from /proc/mounts...
> 
> Don't know if we want to go that way.  Is there no other way?
> 
> But if we do, at least do it in a generic way.  I.e. fuse server can
> tell the kernel to display options A, B and C in /proc/mounts.
> 
> Thanks,
> Miklos

So far I haven't come up with an alternative, other than bad ones. 

Could parse the shadow path from the fuse server with the correct mount
point from 'ps -ef', but there are cases where a fuse server is killed and 
the kernel still thinks it's mounted (and we still might need to find the 
shadow path).

Could write the shadow path to a systemd log and parse it from there, but 
that would break if the log wasn't enabled, and would disappear if the log
was rotated during a long-running mount - and this resolution must happen
every time the famfs cli does most anything (cp, creat, fsck, etc.).

Could write it to a "secret file" somewhere, but that's kinda brittle.

Shadow paths are almost always tmpdir paths that are generated at mount time,
so there really isn't a good way to guess them, and it doesn't seem viable
to require them to be in (e.g.) /tmp in all cases.

Here is what it currently looks like on a running system:

$ grep famfs /proc/mounts
/dev/dax0.0 /mnt/famfs fuse rw,nosuid,nodev,relatime,user_id=0,group_id=0,shadow=/tmp/famfs_shadow_5m0dnH 0 0
$ ps -ef | grep /mnt/famfs | grep -v grep
root       12775       1  0 07:04 ?        00:00:00 /dev/dax0.0 -o daxdev=/dev/dax0.0,shadow=/tmp/famfs_shadow_5m0dnH,fsname=/dev/dax0.0,timeout=31536000.000000 /mnt/famfs

Having a generic approach rather than a '-o' option would be fine with me.
Also happy to entertain other ideas...

Thanks,
John

