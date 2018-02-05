Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from youngberry.canonical.com (youngberry.canonical.com
 [91.189.89.112]) (using TLSv1 with cipher AES256-SHA (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 41D4F21F0DA48
 for <linux-nvdimm@lists.01.org>; Mon,  5 Feb 2018 12:41:10 -0800 (PST)
Subject: Re: [PATCH] libnvdimm: remove redundant assignment to pointer 'dev'
References: <20180205140852.14110-1-colin.king@canonical.com>
 <20180205182039.GA7891@linux.intel.com>
 <CAPcyv4geaysZ803Xtd27YGh0udww+95VaGP6r1Hdxx8SHxfX9w@mail.gmail.com>
From: Colin Ian King <colin.king@canonical.com>
Message-ID: <22ac2ac7-f75f-3cd0-30d7-8cfe7605c8fb@canonical.com>
Date: Mon, 5 Feb 2018 20:46:47 +0000
MIME-Version: 1.0
In-Reply-To: <CAPcyv4geaysZ803Xtd27YGh0udww+95VaGP6r1Hdxx8SHxfX9w@mail.gmail.com>
Content-Language: en-US
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
To: Dan Williams <dan.j.williams@intel.com>, Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: kernel-janitors@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On 05/02/18 18:44, Dan Williams wrote:
> On Mon, Feb 5, 2018 at 10:20 AM, Ross Zwisler
> <ross.zwisler@linux.intel.com> wrote:
>> On Mon, Feb 05, 2018 at 02:08:52PM +0000, Colin King wrote:
>>> From: Colin Ian King <colin.king@canonical.com>
>>>
>>> Pointer dev is being assigned a value that is never read, it is being
>>> re-assigned the same value later on, hence the initialization is redundant
>>> and can be removed.
>>>
>>> Cleans up clang warning:
>>> drivers/nvdimm/pfn_devs.c:307:17: warning: Value stored to 'dev' during
>>> its initialization is never read
>>>
>>> Signed-off-by: Colin Ian King <colin.king@canonical.com>
>>
>> Reviewed-by: Ross Zwisler <ross.zwisler@linux.intel.com>
>>
>> More importantly this fixes a potential NULL pointer dereference.  nd_pfn
>> is checked for NULL a few lines down, but we would have crashed here trying to
>> get nd_pfn->dev.
>>
> 
> No we wouldn't crash. We're just calculating the address, not
> de-referencing a NULL pointer.

Indeed, it's just a warning clean up. Nothing more.

> --
> To unsubscribe from this list: send the line "unsubscribe kernel-janitors" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
