Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x22f.google.com (mail-oi0-x22f.google.com
 [IPv6:2607:f8b0:4003:c06::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id A4FEA20348603
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 09:42:07 -0700 (PDT)
Received: by mail-oi0-x22f.google.com with SMTP id w123-v6so5244458oia.4
 for <linux-nvdimm@lists.01.org>; Fri, 11 May 2018 09:42:07 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180507050926.17243-2-qi.fuli@jp.fujitsu.com>
References: <20180507050926.17243-1-qi.fuli@jp.fujitsu.com>
 <20180507050926.17243-2-qi.fuli@jp.fujitsu.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Fri, 11 May 2018 09:42:06 -0700
Message-ID: <CAPcyv4hcq4jbsP=tSHJ2NqDVAFepmT0UQj-xJVt3KjauHw3ZVA@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] ndctl, util: add OPTION_FILENAME to parse_opt_type
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
To: QI Fuli <qi.fuli@jp.fujitsu.com>
Cc: linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Sun, May 6, 2018 at 10:09 PM, QI Fuli <qi.fuli@jp.fujitsu.com> wrote:
> This patch borrows the OPTION_FILENAME from git to ndctl to make sure
> filename is correct. Some related refactoring is also included:
>   - adds parse_options_prefix() interface
>   - moves is_absolute from util/help.c to util/util.c
>   - adds a new file util/abspath.c
>
> Signed-off-by: QI Fuli <qi.fuli@jp.fujitsu.com>

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
