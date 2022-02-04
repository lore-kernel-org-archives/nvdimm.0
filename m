Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886ED2F21
	for <nvdimm@lists.linux.dev>; Fri,  4 Feb 2022 05:23:13 +0000 (UTC)
Received: by mail-pf1-f176.google.com with SMTP id d187so4145094pfa.10
        for <nvdimm@lists.linux.dev>; Thu, 03 Feb 2022 21:23:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QRfoBad6xaNnxHl59RhSeOObo1h7VnZyGCv6jI7PtEQ=;
        b=fwyKmh86FlojrU+sd/TBHHZ4viFDON2ToZwJPOhNkKpDr0mbFr4tYNZo9B+ah9HkMJ
         eC/vGB496MmU85JHlh/wA7cnxT6CWKSIKEYN6RBpJqF+Gg87BRxvkgUaNBpTOeP7XU7v
         id7fM+Ws+4WgGbSfppglJk/Mu9k+KUKzlgFQY1hKjEuPGWkkH7pXvDIeGF+JcF6XH27I
         8w9twYyX909qLSaaktr2++ubwjGOP7j/nwROAYSzc4K9FkmnwQxpldgrkmFwB2MDVKN1
         2kcwbVXFUOa1ih+lNCQjv7PlCFKgmOLQkO0DTT3jDapPfhx3nczdJKDflj6W6aiubI0p
         E+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QRfoBad6xaNnxHl59RhSeOObo1h7VnZyGCv6jI7PtEQ=;
        b=TKd/nqU00t4kzHfvjrQUeMFEOtdww4nBuxSk3NMq00pjqDsQhbm1zvhxb5xG3qBwzt
         bodLLilYyDRF8JKog8BgP/kSebDh3Wni1ECXYwy7hfTbym8cXoUwj8Xj/WtKXZTzcPeL
         uAK7Bkza5nrk3q+vME4E7x7TI7Ws6jJ+Twz21hqkKSeGBSLfZCH9i7fdrnWgrSZoLhOd
         R1hJq9c1kHdJemiFmR3fCKiwSqCwtcyNs7vQixIHdlRpEKf2ozDtcS6QrJwJTQUG5Ts4
         THtgDmupmLJ36ksbhu9iQXu6UR41UjM2jHZzjftoFSbc9sn9sbLaZeO08O0LLKKDmgjz
         7UGQ==
X-Gm-Message-State: AOAM533RhIiiUxDCLvKBY8gqn7CE+cw+Tw9sZA+oFbbh5wP+xk6JC4cy
	j4UveMaPzjp78Vl75XNAKVEbFZsCmW5kLbX3msnZBA==
X-Google-Smtp-Source: ABdhPJwHAc/oiydG42zh/YFy2yhojJMwzDJLfd2gzwA9VgAmUNWeZj1OWMAW4bLiBRXQIgjKFgKxpvZwQ+knnx1pEdw=
X-Received: by 2002:a05:6a00:1508:: with SMTP id q8mr1395954pfu.3.1643952193051;
 Thu, 03 Feb 2022 21:23:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220128213150.1333552-1-jane.chu@oracle.com> <20220128213150.1333552-2-jane.chu@oracle.com>
 <YfqFWjFcdJSwjRaU@infradead.org> <d0fecaaa-8613-92d2-716d-9d462dbd3888@oracle.com>
 <950a3e4e-573c-2d9f-b277-d1283c7256cd@oracle.com> <YfvbyKdu812To3KY@infradead.org>
In-Reply-To: <YfvbyKdu812To3KY@infradead.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 3 Feb 2022 21:23:00 -0800
Message-ID: <CAPcyv4g7Vqp6Z2+EXHdv95oqQxfdvPDAnzBiRG2KqobaHzOAsg@mail.gmail.com>
Subject: Re: [PATCH v5 1/7] mce: fix set_mce_nospec to always unmap the whole page
To: Christoph Hellwig <hch@infradead.org>
Cc: Jane Chu <jane.chu@oracle.com>, "david@fromorbit.com" <david@fromorbit.com>, 
	"djwong@kernel.org" <djwong@kernel.org>, "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>, 
	"dave.jiang@intel.com" <dave.jiang@intel.com>, "agk@redhat.com" <agk@redhat.com>, 
	"snitzer@redhat.com" <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>, 
	"ira.weiny@intel.com" <ira.weiny@intel.com>, "willy@infradead.org" <willy@infradead.org>, 
	"vgoyal@redhat.com" <vgoyal@redhat.com>, 
	"linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, 
	"nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, 
	"linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Feb 3, 2022 at 5:42 AM Christoph Hellwig <hch@infradead.org> wrote:
>
> On Wed, Feb 02, 2022 at 11:07:37PM +0000, Jane Chu wrote:
> > On 2/2/2022 1:20 PM, Jane Chu wrote:
> > >> Wouldn't it make more sense to move these helpers out of line rather
> > >> than exporting _set_memory_present?
> > >
> > > Do you mean to move
> > >     return change_page_attr_set(&addr, numpages, __pgprot(_PAGE_PRESENT), 0);
> > > into clear_mce_nospec() for the x86 arch and get rid of _set_memory_present?
> > > If so, sure I'll do that.
> >
> > Looks like I can't do that.  It's either exporting
> > _set_memory_present(), or exporting change_page_attr_set().  Perhaps the
> > former is more conventional?
>
> These helpers above means set_mce_nospec and clear_mce_nospec.  If they
> are moved to normal functions instead of inlines, there is no need to
> export the internals at all.

Agree, {set,clear}_mce_nospec() can just move to arch/x86/mm/pat/set_memory.c.
