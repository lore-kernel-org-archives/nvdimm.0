Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x241.google.com (mail-oi0-x241.google.com
 [IPv6:2607:f8b0:4003:c06::241])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id CE11A21F0DA64
 for <linux-nvdimm@lists.01.org>; Mon,  5 Feb 2018 10:38:26 -0800 (PST)
Received: by mail-oi0-x241.google.com with SMTP id c8so21905689oiy.9
 for <linux-nvdimm@lists.01.org>; Mon, 05 Feb 2018 10:44:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180205182039.GA7891@linux.intel.com>
References: <20180205140852.14110-1-colin.king@canonical.com>
 <20180205182039.GA7891@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 5 Feb 2018 10:44:07 -0800
Message-ID: <CAPcyv4geaysZ803Xtd27YGh0udww+95VaGP6r1Hdxx8SHxfX9w@mail.gmail.com>
Subject: Re: [PATCH] libnvdimm: remove redundant assignment to pointer 'dev'
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
Cc: Colin King <colin.king@canonical.com>, kernel-janitors@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 5, 2018 at 10:20 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> On Mon, Feb 05, 2018 at 02:08:52PM +0000, Colin King wrote:
>> From: Colin Ian King <colin.king@canonical.com>
>>
>> Pointer dev is being assigned a value that is never read, it is being
>> re-assigned the same value later on, hence the initialization is redundant
>> and can be removed.
>>
>> Cleans up clang warning:
>> drivers/nvdimm/pfn_devs.c:307:17: warning: Value stored to 'dev' during
>> its initialization is never read
>>
>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>
> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>
> More importantly this fixes a potential NULL pointer dereference.  nd_pfn
> is checked for NULL a few lines down, but we would have crashed here trying to
> get nd_pfn->dev.
>

No we wouldn't crash. We're just calculating the address, not
de-referencing a NULL pointer.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
