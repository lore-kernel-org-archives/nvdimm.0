Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x232.google.com (mail-oi0-x232.google.com
 [IPv6:2607:f8b0:4003:c06::232])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 0D2A82034D8CC
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 10:46:16 -0800 (PST)
Received: by mail-oi0-x232.google.com with SMTP id e10so1876277oiy.8
 for <linux-nvdimm@lists.01.org>; Wed, 21 Feb 2018 10:52:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180221181248.13351-1-ross.zwisler@linux.intel.com>
References: <20180221181248.13351-1-ross.zwisler@linux.intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Wed, 21 Feb 2018 10:52:15 -0800
Message-ID: <CAPcyv4hY8WxKR6ath6khKbx77gEobqC8YBdVvJB3febEAdtWxg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ndctl: tests must use local ndctl
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
Cc: linux-nvdimm@lists.01.org
List-ID: <linux-nvdimm@lists.01.org>

On Wed, Feb 21, 2018 at 10:12 AM, Ross Zwisler
<ross.zwisler@linux.intel.com> wrote:
> Fix a few places in our unit tests where we were using the system ndctl
> instead of the locally built one.  On my system this was leading to false
> positive test failures because my local ndctl didn't support this new
> command:
>
>   ndctl check-namespace --rewrite-log --repair --force --verbose $dev
>
> Signed-off-by: Ross Zwisler <ross.zwisler@linux.intel.com>

Looks good to me:

Reviewed-by: Dan Williams <dan.j.williams@intel.com>
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
