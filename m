Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x233.google.com (mail-oi0-x233.google.com
 [IPv6:2607:f8b0:4003:c06::233])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id C7B2D820A7
 for <linux-nvdimm@lists.01.org>; Mon, 13 Feb 2017 09:32:26 -0800 (PST)
Received: by mail-oi0-x233.google.com with SMTP id s203so54614801oie.1
 for <linux-nvdimm@lists.01.org>; Mon, 13 Feb 2017 09:32:26 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <057ada9967af9e029d2d32cef87b5ab87db4de47.1486750247.git.linda.knippers@hpe.com>
References: <cover.1486750246.git.linda.knippers@hpe.com>
 <057ada9967af9e029d2d32cef87b5ab87db4de47.1486750247.git.linda.knippers@hpe.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Mon, 13 Feb 2017 09:32:25 -0800
Message-ID: <CAPcyv4h6qKU8jSFCDwsf2UyeOL0R_2RfKU=eUETMb0mOjZeOwA@mail.gmail.com>
Subject: Re: [PATCH 3/3] Remove unnecessary newline
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
To: Linda Knippers <linda.knippers@hpe.com>
Cc: "linux-nvdimm@lists.01.org" <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Mon, Feb 13, 2017 at 8:27 AM, Linda Knippers <linda.knippers@hpe.com> wrote:
> Newline in MODULE_PARM_DESC messes up the modprobe output so remove it.

Yes, looks good. When this "messes up" does that mean the output less
pretty, or do you know if it breaks scripts parsing the output? Just
want to be clear on the effects of this change.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
