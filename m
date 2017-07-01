Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yb0-x22b.google.com (mail-yb0-x22b.google.com
 [IPv6:2607:f8b0:4002:c09::22b])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1826121B02BA3
 for <Linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 18:51:35 -0700 (PDT)
Received: by mail-yb0-x22b.google.com with SMTP id e201so43010560ybb.1
 for <Linux-nvdimm@lists.01.org>; Fri, 30 Jun 2017 18:53:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1158028069.2624087.1498868468565@mail.yahoo.com>
References: <1158028069.2624087.1498868468565.ref@mail.yahoo.com>
 <1158028069.2624087.1498868468565@mail.yahoo.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 30 Jun 2017 18:53:08 -0700
Message-ID: <CAPcyv4hiWY-6Bdf=U1QR+bCVvPy8Fq+eaL0+-qzLvbpcEuwn4A@mail.gmail.com>
Subject: Re: ND_MIN_NAMESPACE_SIZE
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Soccer Liu <soccer_liu@yahoo.com>
Cc: "Linux-nvdimm@lists.01.org" <Linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

4M was picked as the smallest "reasonable" size for a disk. We could
make it smaller, but what is the use case?

On Fri, Jun 30, 2017 at 5:21 PM, Soccer Liu <soccer_liu@yahoo.com> wrote:
>  Hi all:
>  I noticed that ND_MIN_NAMESPACE_SIZE is defined as 4MB.
> nvdimm_namespace_common_probe(..){..
>    if (size < ND_MIN_NAMESPACE_SIZE) {
>  dev_dbg(&ndns->dev, "%pa, too small must be at least %#x\n",
>  &size, ND_MIN_NAMESPACE_SIZE);
>  return ERR_PTR(-ENODEV);
>  }...}
> In our configuration, we have a host based software enumerated PMEM device that could be much smaller than 4MB.Because of above failure, no PMEM device was exposed.
> I changed ND_MIN_NAMESPACE_SIZE to smaller size (such as 256 KB) and a smaller size (<4MB) Persistent Memory starts working.Is there any reason that it cannot be smaller?
> Thanks
> Cheng-mean
> _______________________________________________
> Linux-nvdimm mailing list
> Linux-nvdimm@lists.01.org
> https://lists.01.org/mailman/listinfo/linux-nvdimm
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
