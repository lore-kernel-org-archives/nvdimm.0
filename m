Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mail-oi0-x243.google.com (mail-oi0-x243.google.com
 [IPv6:2607:f8b0:4003:c06::243])
 (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 417A02096F356
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 10:57:57 -0700 (PDT)
Received: by mail-oi0-x243.google.com with SMTP id 13-v6so18558522ois.1
 for <linux-nvdimm@lists.01.org>; Thu, 05 Jul 2018 10:57:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20180626153736.6770-2-keith.busch@intel.com>
References: <20180626153736.6770-1-keith.busch@intel.com>
 <20180626153736.6770-2-keith.busch@intel.com>
From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 5 Jul 2018 10:57:56 -0700
Message-ID: <CAPcyv4gVZOfEyMnAjrkOhbH7pX7CYmg4=4d6pTEHEEQdeUQpOw@mail.gmail.com>
Subject: Re: [PATCH 1/2] libnvdimm: Use largest contiguous area for namespace
 size
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
To: Keith Busch <keith.busch@intel.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Tue, Jun 26, 2018 at 8:37 AM, Keith Busch <keith.busch@intel.com> wrote:
> This patch will find the largest free extent to determine the max size
> for a namespace that can be created.
>

This also fixes the "underrun" WARN_ON, right? Can you resend with
that detail in the changelog and add the Fixes tags with a cc: stable?
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
