Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC3F2C83
	for <nvdimm@lists.linux.dev>; Fri, 29 Oct 2021 11:46:37 +0000 (UTC)
Received: by mail-wr1-f50.google.com with SMTP id z14so15764403wrg.6
        for <nvdimm@lists.linux.dev>; Fri, 29 Oct 2021 04:46:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4USXpy4HYDd4725dd4VPkkRl2D3ibOF+yr4vsPBEkE8=;
        b=A4S1LAhHVhcAlkTRzNX9fuGuZAY1nFDO66K6YvKon+ZQjANxdTeXP2kGII385WYI9Q
         Ij5KX8/L0OoTmQHHYNb05fl4PIxpCYvK2XEC5mF2KnRSZs5sLJnbaBswalpDWffoUNGJ
         N4FQnykQgjeHp/CG9lA6JhtnoPNy4OfWB61/K1rbkPYXE5zFchgwdKxk0A7QdbfiXDff
         C1FVOxlK0bbke5RHj+ybYPneAIP8MZI/XyMFzpdqSA8zLD09bBrNg82zwmio63TEagVx
         Dmi89md243x/5qtDfi5g/H4mq/osbs60I15q9+0hAzNRwFoaEwPIDpBl9EzjMdy8FL9r
         QHHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4USXpy4HYDd4725dd4VPkkRl2D3ibOF+yr4vsPBEkE8=;
        b=CxQ0jMZC8Q1ocVe4aR+51PPoPJb+GhTl66PJkgWdf05y88WlGmMEb78RYinGpXswWI
         JixHxWVSah9XVg2qgndX0yusXCF85be93cBzW8SeAkr9JQ/AmMiyGKDPensa9SsqwExf
         OHs/ZVqYvE5U5Rp2pJOrZeONi+8za9Am36vVyr+Pyc58EO7EhHN7fYLxYF8JcLILIQtR
         kxJfVoSvLKkzYuWh5t37Sk/mD5VrR4RYiaa4zmPQeTWEjdM+K0YFo4J80z666BOOlFMk
         hCROq3OfZxnAwP7ne+RYMNwLk2lQpwkE/z0FPZod49dzqFhbUILuFzxhhLf0QWomJrPq
         aW/A==
X-Gm-Message-State: AOAM5322MgRy7Mjn13S9x6SuiLJ1e3jGYsPz1n9z0uxib8PamgWoTIAV
	mAZdn5QK5r12UPdxyJLqygA=
X-Google-Smtp-Source: ABdhPJzTlT2UpuaMBC4cfEXRAY32D5GvOd2OdG1plI8jXT/MbOD36lk+nBoDgi4LlwWwjWLI0IcMbA==
X-Received: by 2002:a5d:47a3:: with SMTP id 3mr13567924wrb.336.1635507996210;
        Fri, 29 Oct 2021 04:46:36 -0700 (PDT)
Received: from [192.168.8.198] ([148.252.129.16])
        by smtp.gmail.com with ESMTPSA id s3sm8421482wmh.30.2021.10.29.04.46.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Oct 2021 04:46:35 -0700 (PDT)
Message-ID: <22255117-52de-4b2d-822e-b4bc50bbc52b@gmail.com>
Date: Fri, 29 Oct 2021 12:46:14 +0100
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [dm-devel] [PATCH 0/6] dax poison recovery with RWF_RECOVERY_DATA
 flag
Content-Language: en-US
To: Dave Chinner <david@fromorbit.com>, "Darrick J. Wong" <djwong@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>, Jane Chu <jane.chu@oracle.com>,
 "dan.j.williams@intel.com" <dan.j.williams@intel.com>,
 "vishal.l.verma@intel.com" <vishal.l.verma@intel.com>,
 "dave.jiang@intel.com" <dave.jiang@intel.com>,
 "agk@redhat.com" <agk@redhat.com>, "snitzer@redhat.com"
 <snitzer@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>,
 "ira.weiny@intel.com" <ira.weiny@intel.com>,
 "willy@infradead.org" <willy@infradead.org>,
 "vgoyal@redhat.com" <vgoyal@redhat.com>,
 "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
 "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-xfs@vger.kernel.org" <linux-xfs@vger.kernel.org>
References: <20211021001059.438843-1-jane.chu@oracle.com>
 <YXFPfEGjoUaajjL4@infradead.org>
 <e89a2b17-3f03-a43e-e0b9-5d2693c3b089@oracle.com>
 <YXJN4s1HC/Y+KKg1@infradead.org>
 <2102a2e6-c543-2557-28a2-8b0bdc470855@oracle.com>
 <YXj2lwrxRxHdr4hb@infradead.org> <20211028002451.GB2237511@magnolia>
 <20211028225955.GA449541@dread.disaster.area>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20211028225955.GA449541@dread.disaster.area>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/21 23:59, Dave Chinner wrote:
[...]
>>> Well, my point is doing recovery from bit errors is by definition not
>>> the fast path.  Which is why I'd rather keep it away from the pmem
>>> read/write fast path, which also happens to be the (much more important)
>>> non-pmem read/write path.
>>
>> The trouble is, we really /do/ want to be able to (re)write the failed
>> area, and we probably want to try to read whatever we can.  Those are
>> reads and writes, not {pre,f}allocation activities.  This is where Dave
>> and I arrived at a month ago.
>>
>> Unless you'd be ok with a second IO path for recovery where we're
>> allowed to be slow?  That would probably have the same user interface
>> flag, just a different path into the pmem driver.
> 
> I just don't see how 4 single line branches to propage RWF_RECOVERY
> down to the hardware is in any way an imposition on the fast path.
> It's no different for passing RWF_HIPRI down to the hardware *in the
> fast path* so that the IO runs the hardware in polling mode because
> it's faster for some hardware.

Not particularly about this flag, but it is expensive. Surely looks
cheap when it's just one feature, but there are dozens of them with
limited applicability, default config kernels are already sluggish
when it comes to really fast devices and it's not getting better.
Also, pretty often every of them will add a bunch of extra checks
to fix something of whatever it would be.

So let's add a bit of pragmatism to the picture, if there is just one
user of a feature but it adds overhead for millions of machines that
won't ever use it, it's expensive.

This one doesn't spill yet into paths I care about, but in general
it'd be great if we start thinking more about such stuff instead of
throwing yet another if into the path, e.g. by shifting the overhead
from linear to a constant for cases that don't use it, for instance
with callbacks or bit masks.

> IOWs, saying that we shouldn't implement RWF_RECOVERY because it
> adds a handful of branches 	 the fast path is like saying that we
> shouldn't implement RWF_HIPRI because it slows down the fast path
> for non-polled IO....
> 
> Just factor the actual recovery operations out into a separate
> function like:

-- 
Pavel Begunkov
