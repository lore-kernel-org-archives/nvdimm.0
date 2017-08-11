Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-yw0-x236.google.com (mail-yw0-x236.google.com
 [IPv6:2607:f8b0:4002:c05::236])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 59C6A21D0DE67
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 17:44:52 -0700 (PDT)
Received: by mail-yw0-x236.google.com with SMTP id s143so14481777ywg.1
 for <linux-nvdimm@lists.01.org>; Thu, 10 Aug 2017 17:47:12 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20170811000000.18672-1-jerry.hoemann@hpe.com>
References: <20170811000000.18672-1-jerry.hoemann@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 10 Aug 2017 17:47:10 -0700
Message-ID: <CAPcyv4grN7RXfkxNfXad79FAKJzwrAxit-xXW4J7n22i-s+Dvg@mail.gmail.com>
Subject: Re: [PATCH] ndctl: New structure definitions.
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
To: Jerry Hoemann <jerry.hoemann@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Aug 10, 2017 at 5:00 PM, Jerry Hoemann <jerry.hoemann@hpe.com> wrote:
> Add structure definitions newly published/modified in v0.85:
>
> https://github.com/HewlettPackard/hpe-nvm/blob/master/Documentation/NFIT_DSM_DDR4_NVDIMM-N_v85.pdf

Are there going to be follow-on patches that make use of these
definitions? I would save this update for when those follow-on patches
are ready.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
