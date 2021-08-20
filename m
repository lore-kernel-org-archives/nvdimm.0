Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFD43FC1
	for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 22:57:06 +0000 (UTC)
Received: by mail-pl1-f169.google.com with SMTP id c4so6787199plh.7
        for <nvdimm@lists.linux.dev>; Fri, 20 Aug 2021 15:57:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=G1Z8mu8s2sgn0mbpfu7ra3LWl3tk+2BaXWQ56zeT5Qo=;
        b=Nt2BeHwjtlSFrM6oUpAp0AEOX1AjgKzHiyuRB0Rdt/NkFHq54pda5iNS/61TJ/a9/M
         WtZ0MUvUAuWfZAkHqP5am1wnus8fD2MJNtfRLgOK5BYxEamRAJy68cbjkG3kKLjc3e6m
         1Ms6ALCk+o8RdYAJUX1suKOU3XJBE72luJok+nKUgFIRJIUiL3D3N2uTn1bOzfRiMLOg
         KTpdgQvnGWwmB9bFrP9a2SK0ZENdHfLcqPa9QmnSQFNoo7bwvdnxzejlRyQ87R+YTrTU
         B+QeZ8y+BYNCRMX0yjp8cW2G7BvJIJhPtgqnqBhSC+lI+hPbKn/JWXQ3x6bi1O+SAZol
         L3iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=G1Z8mu8s2sgn0mbpfu7ra3LWl3tk+2BaXWQ56zeT5Qo=;
        b=MKtu8nGZOgtn34WAkZb8H3ilpJfgeJeQdR03QmuldzTQIZMk5wWpV3AgRudblUawRw
         bbsn4vxnKbl2ZHs/ukFzCPeIPbOQzov4VxWTMq88mgIdb6vadBn+BAodve3WpLKH6fR1
         dp0MXzlAzaWEeJN259v5nmDAjwG9X3rqYUQQiaz15MInlASy5/4VQGKJue/csVczDfcw
         eV2xbIz9FvIuQOxPBjNWwhQOfKvTHAdKxgBjLLyVJPYutSiYwARipUedHMPCDQ9UYWlc
         DLejPgyrZOmgeIPqZrH+C0vB5J5x8VhHMyvi3f2kAlUrBjRTiyvGCjm2NFgxdc1C4V4v
         FFlw==
X-Gm-Message-State: AOAM533RuMNFp51w/7Y/3IyRIw7mLjimLCwM15asvBzWULOQqOQl9KLt
	Oy4MVHHhZnIvP5hjVXAHj8Mx5V1b69HPNKSG2JY48Q==
X-Google-Smtp-Source: ABdhPJxmXpLQCDOV4p/qDFeGVDmICU8dPEjZ+Gjrsjl1tuFZXHOKRbvy6d0ZC+yE1xwMVSAlTTyashdIzkFcEanj6Qo=
X-Received: by 2002:a17:90b:18f:: with SMTP id t15mr6777302pjs.168.1629500225798;
 Fri, 20 Aug 2021 15:57:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20210730100158.3117319-1-ruansy.fnst@fujitsu.com>
 <20210730100158.3117319-7-ruansy.fnst@fujitsu.com> <ec5dd047-a420-8e17-d803-729e052b2377@oracle.com>
In-Reply-To: <ec5dd047-a420-8e17-d803-729e052b2377@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 20 Aug 2021 15:56:54 -0700
Message-ID: <CAPcyv4hitKKPByHkX-syRmc1rmF8B4sGRsGdUDsBAE5-yoBvXw@mail.gmail.com>
Subject: Re: [PATCH RESEND v6 6/9] xfs: Implement ->notify_failure() for XFS
To: Jane Chu <jane.chu@oracle.com>
Cc: Shiyang Ruan <ruansy.fnst@fujitsu.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	Linux NVDIMM <nvdimm@lists.linux.dev>, Linux MM <linux-mm@kvack.org>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	device-mapper development <dm-devel@redhat.com>, "Darrick J. Wong" <djwong@kernel.org>, david <david@fromorbit.com>, 
	Christoph Hellwig <hch@lst.de>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, Aug 5, 2021 at 5:50 PM Jane Chu <jane.chu@oracle.com> wrote:
>
>
> On 7/30/2021 3:01 AM, Shiyang Ruan wrote:
> > +     mapping = VFS_I(ip)->i_mapping;
> > +     if (IS_ENABLED(CONFIG_MEMORY_FAILURE)) {
> > +             for (i = 0; i < rec->rm_blockcount; i++) {
> > +                     error = mf_dax_kill_procs(mapping, rec->rm_offset + i,
> > +                                               *flags);
> > +                     if (error)
> > +                             break;
> > +             }
> > +     }
>
> If a poison is injected to a PMD dax page, after consuming the poison,
> how many SIGBUS signals are expected to be sent to the process?

I think it should only get one. I.e. just like the the generic code
does one shootdown per mapped page regardless of whether that page is
4K, 2M, or 1G. Once the application is notified it should be able to
query the filesystem to determine the full extent of the damage to
files.
