Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from userp2120.oracle.com (userp2120.oracle.com [156.151.31.85])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C15092130D7D0
 for <linux-nvdimm@lists.01.org>; Tue,  6 Aug 2019 10:29:42 -0700 (PDT)
Subject: Re: [PATCH v3 1/2] mm/memory-failure.c clean up around tk
 pre-allocation
References: <1564092101-3865-1-git-send-email-jane.chu@oracle.com>
 <1564092101-3865-2-git-send-email-jane.chu@oracle.com>
 <20190801090651.GC31767@hori.linux.bs1.fc.nec.co.jp>
From: Jane Chu <jane.chu@oracle.com>
Message-ID: <cad86094-c9ce-7bc1-5342-2bb03b512e71@oracle.com>
Date: Tue, 6 Aug 2019 10:26:49 -0700
MIME-Version: 1.0
In-Reply-To: <20190801090651.GC31767@hori.linux.bs1.fc.nec.co.jp>
Content-Language: en-US
List-Unsubscribe: <https://lists.01.org/mailman/options/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/linux-nvdimm/>
List-Post: <mailto:linux-nvdimm@lists.01.org>
List-Help: <mailto:linux-nvdimm-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/linux-nvdimm>,
 <mailto:linux-nvdimm-request@lists.01.org?subject=subscribe>
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="us-ascii"; Format="flowed"; DelSp="yes"
Errors-To: linux-nvdimm-bounces@lists.01.org
Sender: "Linux-nvdimm" <linux-nvdimm-bounces@lists.01.org>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

Hi, Naoya,

Thanks a lot!  v4 on the way. :)

-jane

On 8/1/2019 2:06 AM, Naoya Horiguchi wrote:
> On Thu, Jul 25, 2019 at 04:01:40PM -0600, Jane Chu wrote:
>> add_to_kill() expects the first 'tk' to be pre-allocated, it makes
>> subsequent allocations on need basis, this makes the code a bit
>> difficult to read. Move all the allocation internal to add_to_kill()
>> and drop the **tk argument.
>>
>> Signed-off-by: Jane Chu <jane.chu@oracle.com>
> 
> Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> 
> # somehow I sent 2 acks to 2/2, sorry about the noise.
> 
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
