Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi1-x242.google.com (mail-oi1-x242.google.com
 [IPv6:2607:f8b0:4864:20::242])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 1809E212AB4DE
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jun 2019 09:32:41 -0700 (PDT)
Received: by mail-oi1-x242.google.com with SMTP id w79so4699285oif.10
 for <linux-nvdimm@lists.01.org>; Fri, 28 Jun 2019 09:32:40 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1561723979.git.mchehab+samsung@kernel.org>
 <951fdc9197ffd04cf77168d47685e1299f7d9d73.1561723980.git.mchehab+samsung@kernel.org>
In-Reply-To: <951fdc9197ffd04cf77168d47685e1299f7d9d73.1561723980.git.mchehab+samsung@kernel.org>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 28 Jun 2019 09:32:29 -0700
Message-ID: <CAPcyv4jnz+Cz4sXEDHPiX77BV1piBkbh7LHgs-rUf39NAB7_gw@mail.gmail.com>
Subject: Re: [PATCH 30/43] docs: nvdimm: convert to ReST
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
To: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Fri, Jun 28, 2019 at 5:21 AM Mauro Carvalho Chehab
<mchehab+samsung@kernel.org> wrote:
>
> Rename the nvdimm documentation files to ReST, add an
> index for them and adjust in order to produce a nice html
> output via the Sphinx build system.
>
> At its new index.rst, let's add a :orphan: while this is not linked to
> the main index.rst file, in order to avoid build warnings.
>
> Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

Acked-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
