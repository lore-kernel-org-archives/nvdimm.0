Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from foss.arm.com (usa-sjc-mx-foss1.foss.arm.com [217.140.101.70])
 by ml01.01.org (Postfix) with ESMTP id 9CC71212735DD
 for <linux-nvdimm@lists.01.org>; Mon, 20 May 2019 19:17:16 -0700 (PDT)
Subject: Re: [PATCH v2] mm, memory-failure: clarify error message
References: <1558403523-22079-1-git-send-email-jane.chu@oracle.com>
From: Anshuman Khandual <anshuman.khandual@arm.com>
Message-ID: <f1e4d5e9-e0a7-1a88-f5a5-de9a350e37ef@arm.com>
Date: Tue, 21 May 2019 07:47:26 +0530
MIME-Version: 1.0
In-Reply-To: <1558403523-22079-1-git-send-email-jane.chu@oracle.com>
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
To: Jane Chu <jane.chu@oracle.com>, n-horiguchi@ah.jp.nec.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>



On 05/21/2019 07:22 AM, Jane Chu wrote:
> Some user who install SIGBUS handler that does longjmp out
> therefore keeping the process alive is confused by the error
> message
>   "[188988.765862] Memory failure: 0x1840200: Killing
>    cellsrv:33395 due to hardware memory corruption"
> Slightly modify the error message to improve clarity.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
