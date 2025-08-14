Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AE7F207DE2
	for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 19:19:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755199169; cv=none; b=uT/tHf5gbMOoiMfYX0z3F4qbeXlUdi7o6zOfwmOOk3XObIPCtBxvDLqdnJtHJNfvlzR2hcVSCP4ttR5fy76JzZ8oHgRN53O9tQH6b7FPbJ6fQffXmaplQCNLCaflBIU+03+iODKr9gZ/Bq6SIywbvchFbZCiRaeDn8sm9bv8YJI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755199169; c=relaxed/simple;
	bh=GZrMOqecm9CAXjRBdYJgjbJgjQE37LwuoMcleOFOzN0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cD8LGi/C8mZxZEVaMBjvuIzXj04MkWyn1d1zTcJXTUprcR1GcMsnKO12uA/2oSa+qNLfsIqIvIQ/XzWLDU7saxMfurjUfCa9hhfvX/vNqrqDPAY9UxcNDV7zziXgHqPsFg2QH7IMUHDL3N4P8KSQZAVtNk55iNpTUEfZcPnuobM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=LRLoRYH7; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="LRLoRYH7"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-4b109a95dddso17789471cf.1
        for <nvdimm@lists.linux.dev>; Thu, 14 Aug 2025 12:19:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1755199167; x=1755803967; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GZrMOqecm9CAXjRBdYJgjbJgjQE37LwuoMcleOFOzN0=;
        b=LRLoRYH7WfStWVaCK+6Se/sUDk0qTycJBBEYRACZL++6XHgv5nr70uwkXv9cbJif6o
         S/f34OodDE9c/mq+7uk1x49c9czBUZpv7t7F9zoEQOqGQclO83S+TwJszEcBpXdj7+GQ
         uK61+9ubx/jLi+zZSn8LSx4L1D6AxkI+SxrYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755199167; x=1755803967;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GZrMOqecm9CAXjRBdYJgjbJgjQE37LwuoMcleOFOzN0=;
        b=P3qLADIBme+HvE4heyszfF/jfaT7SToytle3YAOOKfvYgM/dfy8FalJQ0bdD6KXwSG
         t7VWg8iTPw+e7+6djaQKdsv1wJpSglTLz0JS3Qj8uSH3HNbQEGgBKekSiUUBzgwzc09T
         nSHJtF+abq2qjuHG8zWufofAMwnXvvw5dcitDWkK9nR8Rj+x+ycOAD71lAg9zYR64sH9
         gjLDDksKyf9/7HFXTnRASoJJSk98lPlgMiDeTeqoC6ovmeXLV4EMu9P41zMinbdkiJzx
         WFr1w/Fhb4QiuWZGZO8VFBvv0C6EkqAjp1DYAhAFrAFVoGSGvNg5fX1LAg0+TUPix8Rm
         ehQg==
X-Forwarded-Encrypted: i=1; AJvYcCULgT5P53UOaEK+75DaF29yuPHICC0borceK6k66hTmeg+jyD4hFVfP/U3vc/bQ3CR9kGsZimA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzdb+QfoWtw9Y1J16jihJ9cfNZz5+jPSGrOMPawhmOZbklYHL8P
	nnqurbArWY8zux2PUc2cyrbAc5uZZU73++5jV1hOuzvGWYPYU85E294rH9nKkQ0r0TNzM+CX7yx
	NOelTRHukTKTRudLX5dSlUtP1vYj/uRpk87yph/SBSQ==
X-Gm-Gg: ASbGncvpve2bDy+HB3hj4A1MZd6D1APmDU7CdvggjlQjAZVN+kieyofu+MYX67/WJRq
	hrkK6KU16sivH1OBZOxJMvPoD0oQ9mEhPic1wWRiF8kL5CLDEwbzefWotjUe6vO4de8NrLi2Zvv
	nVZ+dVRkrZTny3in1MzTmWdPvmH6gfkmYCZbs8E+7ZPoOY3NAMQ+Elh2De2dQJGC+La1OimsvWB
	uAaUqdxwge7imY=
X-Google-Smtp-Source: AGHT+IFYsASkbgj8LKOURL/sQT2BfijqH2fGAl8jogtfvvYUVEiGcWyswxRpTwKUf9rW7ApmSBhJ6Ltm7fsi8IzNXrY=
X-Received: by 2002:ac8:7d43:0:b0:4af:157e:3823 with SMTP id
 d75a77b69052e-4b10ab61354mr68262251cf.42.1755199166768; Thu, 14 Aug 2025
 12:19:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250703185032.46568-1-john@groves.net> <20250703185032.46568-15-john@groves.net>
 <CAJfpegv19wFrT0QFkwFrKbc6KXmktt0Ba2Lq9fZoihA=eb8muA@mail.gmail.com>
 <20250814171941.GU7942@frogsfrogsfrogs> <CAJfpegv8Ta+w4CTb7gvYUTx3kka1-pxcWX_ik=17wteU9XBT1g@mail.gmail.com>
 <20250814185503.GZ7942@frogsfrogsfrogs>
In-Reply-To: <20250814185503.GZ7942@frogsfrogsfrogs>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 14 Aug 2025 21:19:15 +0200
X-Gm-Features: Ac12FXwFvJoOQXfTVyVQkORoWxApgAqsvX9WIX8VNMR4nJ4kVqHzj7yLc5euRJ4
Message-ID: <CAJfpeguxZVVddGQsMtM35tVo0dD118hKBf9KJcuhSBznzqUzSg@mail.gmail.com>
Subject: Re: [RFC V2 14/18] famfs_fuse: GET_DAXDEV message and daxdev_table
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

On Thu, 14 Aug 2025 at 20:55, Darrick J. Wong <djwong@kernel.org> wrote:

> Or do we move the backing_files_map out of CONFIG_FUSE_PASSTHROUGH and
> then let fuse-iomap/famfs extract the block/dax device from that?
> Then the backing_id/device cookie would be the same across a fuse mount.

Yes.

Thanks,
Miklos
