Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7E54DA0A
	for <nvdimm@lists.linux.dev>; Mon, 12 Feb 2024 22:08:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707775723; cv=none; b=mGiONxRkAZKiqNjZrDRqpdQhsXqycA95fYR4n/QOw7Khc7xhWp8OuqoTqV9LJs3mj8eIfLh51JhiD7bIJh/biuCAPbYVHTiPt1EIFv22QBkuIf8B32SwrnVsjGonvJuirVW6CwHbXvOGCYyfDxXZgXZc3RFTQrCOPgE4Ty41xgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707775723; c=relaxed/simple;
	bh=gAbe+DaZz7ho9Xs/O1+sZUd+Q7Ss16k+L7gT59qsNpo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AZ5bCJOA53EzQlxHh9DxrcU3h0FTEaxAta6kabaTASGKPZh6P1UqlwmeisyN/9tVRBJtkexGiJ6G+Gdxa8qdiuaNgmgMi0J0gX61t6FADihCaYpzgqpch3upTJp4reNfkGB4ImT7uBConR9aaSg4V1ihv70RH0tn1owHTn2LPa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=PlF0RXF3; arc=none smtp.client-ip=209.85.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="PlF0RXF3"
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-a2f79e79f0cso576362066b.2
        for <nvdimm@lists.linux.dev>; Mon, 12 Feb 2024 14:08:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1707775719; x=1708380519; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uavn2lIFtdjKttrhD59+foSMVfR1WVZExe9j9lqEZVs=;
        b=PlF0RXF3TqDw+qfB97zaNoQoHVdoEm52PnYDwAdPUbvHS2NuPKGQ3ehBsMQb6HM//E
         yTsNsCH+NyeFpkrLqEcDDmb1BiUmPNlkeA+LHROJ05wkGyMEYBUfbBGzZZNmTcxRkQne
         EyUfF+7oD7a6wrW26ofzUpPNA+ZpflyWnuZDg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707775719; x=1708380519;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uavn2lIFtdjKttrhD59+foSMVfR1WVZExe9j9lqEZVs=;
        b=HLRV9E9k0qYV4PgVJ82rtOZ7cR7YO6evtf9/nulc2lju//3tgCo6a1m8uV+LvYnsqi
         S5LPqTPkwa2H5JUeWIIqZatm0dBllIa0drvOGmWQDVJGGm8F+X5JxF+DC4+7eLAp5C1b
         P4dmULxoCny6ivGmgVW3wPMEKUk0UqHnx/8hrcCMO54pK6FZyE8TSauqs/ZCk3VRc8K6
         jGIu9X9pJ96z82Wysymhnob/4S709CtFc+ShS2GWHMNnzeFp6cLGrWRU7iaM9dQMgG5Z
         VLCAHaUkeqs51oUVv1m6Zt6wAgRhXGo7ix6TNFVLxI4kwOI5HNzdGzu4vOJjyT9q8FCf
         z/OQ==
X-Forwarded-Encrypted: i=1; AJvYcCUlU3CYtRFXY+PweunG7x64IUKTfrbvJFXucH1NkxCGDrI1JK9RSSKnrzWg1SFIMSSKuFeMuhzA3+BPkuZeeWZX3g/zIeE8
X-Gm-Message-State: AOJu0YyBIRvN7CMw7qT81O+ug5Bz3aSijLBbD5VkhM+wsHNyUTiZg62V
	98odKOlhBGeXTt4MjFFwhIBqngP4buo5+caTXVZ/nQv10VnS4YbfZZX7e0qRmlK6KtUWqoHKxnv
	yW8k=
X-Google-Smtp-Source: AGHT+IECc2A8iQYqYfZRxFKCbhWwjuvEVnfI+HWfNHAZpIt4bxMdOL7jPPQSO6EmOk5JXM5OVrwXxQ==
X-Received: by 2002:a17:906:ccc9:b0:a38:421c:876c with SMTP id ot9-20020a170906ccc900b00a38421c876cmr5988815ejb.19.1707775719717;
        Mon, 12 Feb 2024 14:08:39 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCXgR8TWMB1rYdqu9haRG65Wgw5fhGljM8AY/Y9xJ4S9IMjiYzcsiyThbSPMv/LEI8mIsiDYWAfm0BswE4avxG6l00//3br0
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id gl15-20020a170906e0cf00b00a367bdce1fcsm620611ejb.64.2024.02.12.14.08.37
        for <nvdimm@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Feb 2024 14:08:38 -0800 (PST)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-55ff5f6a610so4427845a12.3
        for <nvdimm@lists.linux.dev>; Mon, 12 Feb 2024 14:08:37 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCWAHZ7ll6Fkx2ruGL7zHdCbA/zFttKknyhMBMPcDk85I6Dm6+BFgftX98Ts5XxahOdW4t8a3cFWdJ7Q5aCp87E0fcIh7F2m
X-Received: by 2002:aa7:cd66:0:b0:561:f173:6611 with SMTP id
 ca6-20020aa7cd66000000b00561f1736611mr60172edb.35.1707775717604; Mon, 12 Feb
 2024 14:08:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240212163101.19614-1-mathieu.desnoyers@efficios.com>
 <20240212163101.19614-6-mathieu.desnoyers@efficios.com> <65ca95d086dfd_d2d429470@dwillia2-xfh.jf.intel.com.notmuch>
In-Reply-To: <65ca95d086dfd_d2d429470@dwillia2-xfh.jf.intel.com.notmuch>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 12 Feb 2024 14:08:20 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiqaENZFBiAihFxdLr2E+kSM4P64M3uPzwT4-K9NiVSmw@mail.gmail.com>
Message-ID: <CAHk-=wiqaENZFBiAihFxdLr2E+kSM4P64M3uPzwT4-K9NiVSmw@mail.gmail.com>
Subject: Re: [PATCH v5 5/8] virtio: Treat alloc_dax() -EOPNOTSUPP failure as non-fatal
To: Dan Williams <dan.j.williams@intel.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Arnd Bergmann <arnd@arndb.de>, 
	Dave Chinner <david@fromorbit.com>, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Vishal Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Matthew Wilcox <willy@infradead.org>, 
	Russell King <linux@armlinux.org.uk>, linux-arch@vger.kernel.org, 
	linux-cxl@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-xfs@vger.kernel.org, dm-devel@lists.linux.dev, nvdimm@lists.linux.dev, 
	linux-s390@vger.kernel.org, Alasdair Kergon <agk@redhat.com>, 
	Mike Snitzer <snitzer@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, 12 Feb 2024 at 14:04, Dan Williams <dan.j.williams@intel.com> wrote:
>
> This works because the internals of virtio_fs_cleanup_dax(), "kill_dax()
> and put_dax()", know how to handle a NULL @dax_dev. It is still early
> days with the "cleanup" helpers, but I wonder if anyone else cares that
> the DEFINE_FREE() above does not check for NULL?

Well, the main reason for DEFINE_FREE() to check for NULL is not
correctness, but code generation. See the comment about kfree() in
<linux/cleanup.h>:

 * NOTE: the DEFINE_FREE()'s @free expression includes a NULL test even though
 * kfree() is fine to be called with a NULL value. This is on purpose. This way
 * the compiler sees the end of our alloc_obj() function as [...]

with the full explanation there.

Now, whether the code wants to actually use the cleanup() helpers for
a single use-case is debatable.

But yes, if it does, I suspect it should use !IS_ERR_OR_NULL(ptr).

            Linus
