Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x231.google.com (mail-ot0-x231.google.com
 [IPv6:2607:f8b0:4003:c0f::231])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 2659821A143F1
 for <linux-nvdimm@lists.01.org>; Fri,  9 Jun 2017 13:52:40 -0700 (PDT)
Received: by mail-ot0-x231.google.com with SMTP id a2so44540453oth.2
 for <linux-nvdimm@lists.01.org>; Fri, 09 Jun 2017 13:53:50 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <593B008C.60502@hpe.com>
References: <149698606405.12023.3409783083697026090.stgit@dwillia2-desk3.amr.corp.intel.com>
 <593B008C.60502@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 9 Jun 2017 13:53:49 -0700
Message-ID: <CAPcyv4gJUqb_KHsZOAexEmaEn4MxRW--tTT9zAWFfAMqiAW05g@mail.gmail.com>
Subject: Re: [ndctl PATCH] util: distinguish error codes for sysfs_{read,
 write}_attr()
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 9, 2017 at 1:09 PM, Linda Knippers <linda.knippers@hpe.com> wrote:
> On 06/09/2017 01:27 AM, Dan Williams wrote:
>> There are occasions where it would be good to know the difference
>> between a sysfs attribute failing to be accessed because we could not
>> open versus could not read/write.
>
> I think it would be really helpful if you returned the actual errno value
> rather than something hard coded.  The most common reason for not being able to write
> something is that it requires running as root, in which case you should
> get an EPERM. I think an accurate errno will help users figure out what's
> gone wrong.

Will do.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
