Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from tyo162.gate.nec.co.jp (tyo162.gate.nec.co.jp [114.179.232.162])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 21DA9212FD4E0
 for <linux-nvdimm@lists.01.org>; Thu,  1 Aug 2019 02:09:46 -0700 (PDT)
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: Re: [PATCH v3 1/2] mm/memory-failure.c clean up around tk
 pre-allocation
Date: Thu, 1 Aug 2019 09:06:51 +0000
Message-ID: <20190801090651.GC31767@hori.linux.bs1.fc.nec.co.jp>
References: <1564092101-3865-1-git-send-email-jane.chu@oracle.com>
 <1564092101-3865-2-git-send-email-jane.chu@oracle.com>
In-Reply-To: <1564092101-3865-2-git-send-email-jane.chu@oracle.com>
Content-Language: ja-JP
Content-ID: <1FD28E0D8B0232438C43D1B28666B164@gisp.nec.co.jp>
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
To: Jane Chu <jane.chu@oracle.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 25, 2019 at 04:01:40PM -0600, Jane Chu wrote:
> add_to_kill() expects the first 'tk' to be pre-allocated, it makes
> subsequent allocations on need basis, this makes the code a bit
> difficult to read. Move all the allocation internal to add_to_kill()
> and drop the **tk argument.
> 
> Signed-off-by: Jane Chu <jane.chu@oracle.com>

Acked-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>

# somehow I sent 2 acks to 2/2, sorry about the noise.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
