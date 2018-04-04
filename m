Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-pl0-x236.google.com (mail-pl0-x236.google.com
 [IPv6:2607:f8b0:400e:c01::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 550032264A1FE
 for <linux-nvdimm@lists.01.org>; Wed,  4 Apr 2018 05:20:34 -0700 (PDT)
Received: by mail-pl0-x236.google.com with SMTP id b6-v6so11706541pla.11
 for <linux-nvdimm@lists.01.org>; Wed, 04 Apr 2018 05:20:34 -0700 (PDT)
Date: Wed, 4 Apr 2018 22:20:25 +1000
From: Balbir Singh <bsingharora@gmail.com>
Subject: Re: [RESEND v2 4/4] powerpc/powernv: Create platform devs for
 nvdimm buses
Message-ID: <20180404222025.0de361ef@gmail.com>
In-Reply-To: <20180403142415.30083-4-oohall@gmail.com>
References: <20180403142415.30083-1-oohall@gmail.com>
 <20180403142415.30083-4-oohall@gmail.com>
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
To: Oliver O'Halloran <oohall@gmail.com>
Cc: linuxppc-dev@lists.ozlabs.org, linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed,  4 Apr 2018 00:24:15 +1000
Oliver O'Halloran <oohall@gmail.com> wrote:

> Scan the devicetree for an nvdimm-bus compatible and create
> a platform device for them.
> 
> Signed-off-by: Oliver O'Halloran <oohall@gmail.com>
> ---

Acked-by: Balbir Singh <bsingharora@gmail.com>

_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
