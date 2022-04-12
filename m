Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF4501FA1
	for <nvdimm@lists.linux.dev>; Tue, 12 Apr 2022 04:57:47 +0000 (UTC)
Received: by mail-pl1-f176.google.com with SMTP id c23so15796787plo.0
        for <nvdimm@lists.linux.dev>; Mon, 11 Apr 2022 21:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=intel-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8TleCaBIhpvoj6MzJmrMyC3ucMSm6WO1y+eL8xleJY4=;
        b=fkN36mDpM4Pd1sCv3rNuy9oyYD/gLOwueus4xphJV1YDbeNRSQ8IyujzwsptiZfgYe
         QUQIV9qghorMpdWWz6Mmsr/1DpHVZ96zqos/O3uhBAyz4TBRkDPpFJ5YoWKm0lCFZweQ
         RoEFhL/uQjowL2aggfNFdXl2Ztg3A9451oiIjvEilBdbF+7t1islEN8KsPhMNJASWFOK
         SUVweWmAjr6bfH/tyV4dylbfizqkoRZTCLZaofjld5K7oDzCT9ORDsz4TyjMGKUqQ8M4
         Qet/LWoJSVXRFpDjGoHVJDsMMopWIZP4HzpS68RD9q73tLwybQtTxPuEsqT+1brdIvEZ
         etIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8TleCaBIhpvoj6MzJmrMyC3ucMSm6WO1y+eL8xleJY4=;
        b=ZgAC0XwpkQerYwe4HehlbWBPxZprsMTL1zHs6I0xMiZPq9V+enCOuv446NfGLye/wW
         1wNVfWw0+YsvzmaaQZv7Ff+J7J1mgdnutbDKxnc8CyH8qjfyh4q36pf85DbQBY4s1YiE
         ZgROvhauai6SQzUyQG8E2o4RDm5fcCWJFSp1vm7AHIGqOAITVAWzCg8pDHRTrzW5GYip
         x1L8xJ27ul3dpH8d+FLAReDbNDm59UjPP7ALmeRPmq+hDYs0TLnPmiPCkZob9vYd8Vtm
         CIzIdkrxHRggBwqIVpze90RKLjg0KMh4KVtK6UHgKltWtI5/u4TZg8yHeAxExuIvsN89
         RJQA==
X-Gm-Message-State: AOAM531/44PBPYwlUX0LiDcyVofWAnaOWK0HgIacr02WLp7gALU5HkDb
	vjLtTnmstxnuqePKuI1fsx8NQCrWv3MK+f5ZFWUDLA==
X-Google-Smtp-Source: ABdhPJxBATyoJAyblOakoZzlFS+GtSy3AbBTLdouj+8YmPDRCb1cpkksbCSmeWKkXDHtWwI5LR7XG/b+KrOX8AklXlQ=
X-Received: by 2002:a17:902:eb92:b0:158:4cc9:698e with SMTP id
 q18-20020a170902eb9200b001584cc9698emr12430897plg.147.1649739467468; Mon, 11
 Apr 2022 21:57:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20220405194747.2386619-1-jane.chu@oracle.com> <20220405194747.2386619-5-jane.chu@oracle.com>
In-Reply-To: <20220405194747.2386619-5-jane.chu@oracle.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 11 Apr 2022 21:57:36 -0700
Message-ID: <CAPcyv4jpOss6hzPgM913v_QsZ+PB6Jzo1WV=YdUvnKZiwtfjiA@mail.gmail.com>
Subject: Re: [PATCH v7 4/6] dax: add DAX_RECOVERY flag and .recovery_write dev_pgmap_ops
To: Jane Chu <jane.chu@oracle.com>
Cc: david <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>, 
	Christoph Hellwig <hch@infradead.org>, Vishal L Verma <vishal.l.verma@intel.com>, 
	Dave Jiang <dave.jiang@intel.com>, Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>, 
	device-mapper development <dm-devel@redhat.com>, "Weiny, Ira" <ira.weiny@intel.com>, 
	Matthew Wilcox <willy@infradead.org>, Vivek Goyal <vgoyal@redhat.com>, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Linux NVDIMM <nvdimm@lists.linux.dev>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-xfs <linux-xfs@vger.kernel.org>, 
	X86 ML <x86@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, Apr 5, 2022 at 12:48 PM Jane Chu <jane.chu@oracle.com> wrote:
>
> Introduce DAX_RECOVERY flag to dax_direct_access(). The flag is
> not set by default in dax_direct_access() such that the helper
> does not translate a pmem range to kernel virtual address if the
> range contains uncorrectable errors.  When the flag is set,
> the helper ignores the UEs and return kernel virtual adderss so
> that the caller may get on with data recovery via write.

It strikes me that there is likely never going to be any other flags
to dax_direct_access() and what this option really is an access type.
I also find code changes like this error prone to read:

 -       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
 +       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, 0, &kaddr, NULL);

...i.e. without looking at the prototype, which option is the nr_pages
and which is the flags?

So how about change 'int flags' to 'enum dax_access_mode mode' where
dax_access_mode is:

/**
 * enum dax_access_mode - operational mode for dax_direct_access()
 * @DAX_ACCESS: nominal access, fail / trim access on encountering poison
 * @DAX_RECOVERY_WRITE: ignore poison and provide a pointer suitable
for use with dax_recovery_write()
 */
enum dax_access_mode {
    DAX_ACCESS,
    DAX_RECOVERY_WRITE,
};

Then the conversions look like this:

 -       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1, &kaddr, NULL);
 +       rc = dax_direct_access(iter->iomap.dax_dev, pgoff, 1,
DAX_ACCESS, &kaddr, NULL);

...and there's less chance of confusion with the @nr_pages argument.
