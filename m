Return-Path: <linux-nvdimm-bounces@lists.01.org>
Received: from mga09.intel.com (mga09.intel.com [134.134.136.24])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by ml01.01.org (Postfix) with ESMTPS id 48E1B2096F344
 for <linux-nvdimm@lists.01.org>; Thu,  5 Jul 2018 10:58:55 -0700 (PDT)
Date: Thu, 5 Jul 2018 11:58:18 -0600
From: Keith Busch <keith.busch@intel.com>
Subject: Re: [PATCH 1/2] libnvdimm: Use largest contiguous area for namespace
 size
Message-ID: <20180705175817.GA32647@localhost.localdomain>
References: <20180626153736.6770-1-keith.busch@intel.com>
 <20180626153736.6770-2-keith.busch@intel.com>
 <CAPcyv4gVZOfEyMnAjrkOhbH7pX7CYmg4=4d6pTEHEEQdeUQpOw@mail.gmail.com>
MIME-Version: 1.0
Content-Disposition: inline
In-Reply-To: <CAPcyv4gVZOfEyMnAjrkOhbH7pX7CYmg4=4d6pTEHEEQdeUQpOw@mail.gmail.com>
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
To: Dan Williams <dan.j.williams@intel.com>
Cc: Yasunori Goto <y-goto@jp.fujitsu.com>, linux-nvdimm <linux-nvdimm@lists.01.org>
List-ID: <linux-nvdimm@lists.01.org>

On Thu, Jul 05, 2018 at 10:57:56AM -0700, Dan Williams wrote:
> On Tue, Jun 26, 2018 at 8:37 AM, Keith Busch <keith.busch@intel.com> wrote:
> > This patch will find the largest free extent to determine the max size
> > for a namespace that can be created.
> >
> 
> This also fixes the "underrun" WARN_ON, right? Can you resend with
> that detail in the changelog and add the Fixes tags with a cc: stable?

Sure thing, will resend shortly.
_______________________________________________
Linux-nvdimm mailing list
Linux-nvdimm@lists.01.org
https://lists.01.org/mailman/listinfo/linux-nvdimm
