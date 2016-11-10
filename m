Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from NAM02-BL2-obe.outbound.protection.outlook.com
 (mail-bl2nam02on0726.outbound.protection.outlook.com
 [IPv6:2a01:111:f400:fe46::726])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id E981A81D39
 for <linux-nvdimm@lists.01.org>; Wed,  9 Nov 2016 21:43:50 -0800 (PST)
From: "Elliott, Robert (Persistent Memory)" <elliott@hpe.com>
Subject: RE: [PATCH] libnvdimm: check and clear poison before writing to pmem
Date: Thu, 10 Nov 2016 05:43:51 +0000
Message-ID: <DF4PR84MB01690CEBF838400996F31043ABB80@DF4PR84MB0169.NAMPRD84.PROD.OUTLOOK.COM>
References: <147873364251.45471.9613527969861188296.stgit@djiang5-desk3.ch.intel.com>
 <20161110001405.GA26806@omniknight.lm.intel.com>
 <CAPcyv4g8jOp4jKH5+Cn2TEhhCZU0Mu7A5PXWAQHmAP7UO4Pk9Q@mail.gmail.com>
In-Reply-To: <CAPcyv4g8jOp4jKH5+Cn2TEhhCZU0Mu7A5PXWAQHmAP7UO4Pk9Q@mail.gmail.com>
Content-Language: en-US
MIME-Version: 1.0
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
To: Dan Williams <dan.j.williams@intel.com>, Vishal Verma <vishal.l.verma@intel.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>



> -----Original Message-----
> From: Linux-nvdimm [mailto:linux-nvdimm-bounces@lists.01.org] On
> Behalf Of Dan Williams
> Sent: Wednesday, November 09, 2016 6:55 PM
> To: Vishal Verma <vishal.l.verma@intel.com>
> Cc: linux-nvdimm@lists.01.org
> Subject: Re: [PATCH] libnvdimm: check and clear poison before writing
> to pmem
...
> >> @@ -233,12 +234,27 @@ static int nsio_rw_bytes(struct
> nd_namespace_common *ndns,
> >
> >> +                             int rc;
> >> +
> >> +                             rc = nvdimm_clear_poison(&ndns->dev, offset,
> >> +                                                      size);
> >> +                             if (rc != size)
> >> +                                     return -EIO;
> >
> > I'm not sure of this myself - perhaps a question to Dan -
> > Is it safe to return EIO here? We have potentially cleared some
> > poison, and lost some data, but subsequent reads will not indicate
> > any errors, returning either 0s or something unpredictable. Would
> > it be better to simply go ahead with the write even if we weren't
> > able to clear the whole range?
> 
> Good point, the interface allows partial completions, so it's
> reasonable to go write what we were able to clear.  However that only
> shrinks the exposure not eliminate it since we could immediately
> crash for some other reason before the write completes.
> 
> We would [like] an error clearing interface that had deterministic data
> after clearing to do something better, but I can get on board with
> writing new data after a partial completion.

You should call badblocks_clear for the blocks for which uncorrectable
errors were successfully cleared.  Future writes constrained to that
area will work fine.

nsio_rw_bytes doesn't return how many bytes were successfully written,
so I don't think doing a partial memcpy_to_pmem would be helpful.


---
Robert Elliott, HPE Persistent Memory



_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
