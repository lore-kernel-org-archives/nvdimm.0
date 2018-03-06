Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 3782822135D47
 for <linux-nvdimm@lists.01.org>; Tue,  6 Mar 2018 11:07:20 -0800 (PST)
Received: by mail-oi0-x243.google.com with SMTP id c83so524877oib.1
 for <linux-nvdimm@lists.01.org>; Tue, 06 Mar 2018 11:13:35 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180305184219.GA30168@linux.intel.com>
References: <20180227172952.22177-1-ross.zwisler@linux.intel.com>
 <20180305184219.GA30168@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Tue, 6 Mar 2018 11:13:33 -0800
Message-ID: <CAPcyv4iR-AMOK0wphTm4cPxypjv_z=qwPJvKs__1md1qbPvJOg@mail.gmail.com>
Subject: Re: [PATCH 1/3] nfit_test: improve structure offset handling
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
To: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Mar 5, 2018 at 10:42 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Tue, Feb 27, 2018 at 10:29:50AM -0700, Ross Zwisler wrote:
>> In nfit_test0_setup() and nfit_test1_setup() we keep an 'offset' value
>> which we use to calculate where in our 'nfit_buf' we will place our next
>> structure.  The handling of 'offset' and the calculation of the placement
>> of the next structure is a bit inconsistent, though.  We don't update
>> 'offset' after we insert each structure, sometimes causing us to update it
>> for multiple structures' sizes at once.  When calculating the position of
>> the next structure we aren't always able to just use 'offset', but
>> sometimes have to add in other structure sizes as well.
>>
>> Fix this by updating 'offset' after each structure insertion in a
>> consistent way, allowing us to always calculate the position of the next
>> structure to be inserted by just using 'nfit_buf + offset'.
>>
>> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>
> Ping on this series.

All of these look good to me, applied.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
