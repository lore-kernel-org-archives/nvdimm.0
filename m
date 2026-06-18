Received: from sender4-op-o15.zoho.com (sender4-op-o15.zoho.com [136.143.188.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6311175A89;
	Thu, 18 Jun 2026 01:18:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=136.143.188.15
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781745532; cv=pass; b=ITqgkAziNMkjb8eZkMQJc7AAdtC/poVhSkbWZXeq/d2neOSGwjEq30iOTg+SX+t+h3Odgt/lbqlJk+/F+Nrqxi2JItTu2KctdqdvhYKU0g7O0vh9Kte88YSBztmsv0L8AaeNr17KNQyFFvxK78VxBfySjViMO2J2tjKXfyIG714=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781745532; c=relaxed/simple;
	bh=s8SwkW2TJEtXTUlOSaAhFW9HuWQZ9cgj+K0qH9V0WyU=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=GuvtQLZiNJu5U0j19MHMYzyUbPqkGDEhjpYO9RaALiQD7mgCmjN8bFvKtG4CPEGI9w7VqxUr9DxqBbl4I0esORLSSpHM88vGmt2bEQnhdWY3fKg96MQHcjzjrZAeuu3EkKmln4W2iw6kH+UiinLkYsS039cZVIgQvcl0NQg1XBw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty; spf=pass smtp.mailfrom=linux.beauty; dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b=WahXT65h; arc=pass smtp.client-ip=136.143.188.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.beauty
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.beauty
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.beauty header.i=me@linux.beauty header.b="WahXT65h"
ARC-Seal: i=1; a=rsa-sha256; t=1781745527; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=EdpoeX0FZB18FpBrHNsIVPc5zLqwlovG27JC4w4yulGEpVe+a7xZvyTim8GdJWtjqrHTAtnooVST9YpeJUPv22X9iYd3w1I3VFp2qhREFUXPni2pDQr0O+IgwbDErlnOpdrxAnep8ZmWgdX2lT96MYJFg577zJHbnl5EPiAhJ/w=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1781745527; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=gvtmqQu+4izQ+z8vCyEncJGkS/9pjYX+E8AlS+ZmjMw=; 
	b=XXjgw7jAXBs+D5HoEfn04FzVVUcK8jxMkJk07YeLjyYv8hZhUjgkt3cHBI8mAKM+h5aNEtbBEW+3vFb2BVM31EOjCHFW3opyuIjLz0OzCNcCHpx2L8HUBkDjApu86w9rvT0W7+8Kjgt2mcNB/f8DtgzG4T/FIK15mr3ouVMSj2I=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=linux.beauty;
	spf=pass  smtp.mailfrom=me@linux.beauty;
	dmarc=pass header.from=<me@linux.beauty>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1781745527;
	s=zmail; d=linux.beauty; i=me@linux.beauty;
	h=Date:Date:From:From:To:To:Cc:Cc:Message-ID:In-Reply-To:References:Subject:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To;
	bh=gvtmqQu+4izQ+z8vCyEncJGkS/9pjYX+E8AlS+ZmjMw=;
	b=WahXT65hFt3l/XSNRy6KdvKlm9CSvwbZFWoQ8xEPZcE/+l8TEiBN9g1TkaKhgaZV
	IaeWq3LKnGwmBfBbONrJxKnhMvosucg+c1sqDtY92AA/IuQCcsoIBFPnsY5A8F6tuSg
	S4n92QLeM6Z7CN+qaFk38FIufmiptRPoLmHWRSqM=
Received: from mail.zoho.com by mx.zohomail.com
	with SMTP id 1781745523625334.74062508792883; Wed, 17 Jun 2026 18:18:43 -0700 (PDT)
Date: Thu, 18 Jun 2026 09:18:43 +0800
From: Li Chen <me@linux.beauty>
To: "Alison Schofield" <alison.schofield@intel.com>
Cc: "Pankaj Gupta" <pankaj.gupta.linux@gmail.com>,
	"Dan Williams" <dan.j.williams@intel.com>,
	"Vishal Verma" <vishal.l.verma@intel.com>,
	"Dave Jiang" <dave.jiang@intel.com>,
	"Ira Weiny" <ira.weiny@intel.com>,
	"virtualization" <virtualization@lists.linux.dev>,
	"nvdimm" <nvdimm@lists.linux.dev>,
	"linux-kernel" <linux-kernel@vger.kernel.org>
Message-ID: <19ed84f1b63.4eb3c0703221791.2736506052608115754@linux.beauty>
In-Reply-To: <aixTFVGZVDaCxMis@aschofie-mobl2.lan>
References: <20260609120726.1714780-1-me@linux.beauty> <aixTFVGZVDaCxMis@aschofie-mobl2.lan>
Subject: Re: [PATCH v4 0/7] nvdimm: virtio_pmem: fix request lifetime and
 converge broken queue failures
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: Zoho Mail
X-Mailer: Zoho Mail

Hi Alison,


 ---- On Sat, 13 Jun 2026 02:42:29 +0800  Alison Schofield <alison.schofiel=
d@intel.com> wrote ---=20
 > On Tue, Jun 09, 2026 at 08:07:14PM +0800, Li Chen wrote:
 > > Hi,
 >=20
 > Hi Li Chen,
 >=20
 > In case you missed it, a Sashiko AI review of this set has posted
 > feedback. Please take a look.
 >=20
 > https://sashiko.dev/#/patchset/20260609120726.1714780-1-me%40linux.beaut=
y
 >=20
 > -- Alison

Thanks for checking and for the reminder.

I will also keep watching Sashiko's review results for this and future
rerolls, and will fold in any issues that look valid.


Regards,
Li=E2=80=8B

