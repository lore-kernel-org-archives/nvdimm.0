Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-ot0-x22f.google.com (mail-ot0-x22f.google.com
 [IPv6:2607:f8b0:4003:c0f::22f])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 6380A2034D8EF
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 15:53:25 -0800 (PST)
Received: by mail-ot0-x22f.google.com with SMTP id b15so3090686otf.3
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 15:59:25 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <151925075889.65338.1771943064286480835.stgit@djiang5-desk3.ch.intel.com>
References: <151925075889.65338.1771943064286480835.stgit@djiang5-desk3.ch.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Feb 2018 15:59:24 -0800
Message-ID: <CAPcyv4j7Rxy+B_dpM3Nx-TaRqRyY9SNysxB0ZBN=Q4DYmn5fvw@mail.gmail.com>
Subject: Re: [PATCH 1/2] ndctl: add more error outs to update firmware and
 enable verbose debug
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
To: Dave Jiang <dave.jiang@intel.com>
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 21, 2018 at 2:05 PM, Dave Jiang <dave.jiang@intel.com> wrote:
> update-firmware is missing verbose option for debug outputs. Also adding
> additional error outs to give better indication if something has failed
> and why.

Looks good to me.

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
