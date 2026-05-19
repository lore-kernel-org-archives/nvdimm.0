Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D1361A9FA4
	for <nvdimm@lists.linux.dev>; Tue, 19 May 2026 03:48:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.112
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779162539; cv=none; b=C787SIlBp9GVtqAadfS1yKl+znPeZMiZOU8IA6JpI9jB8JN3/D9ekoufMleL2CNxYZLos5m60IZq+5F5wvBXyXsDE396XzIB3+1JhAIjl7lgkwreaanLhzuE7STaaPb7PhKLj4r4PMbyQNT3xHCXUDyCs4LwFfVj3Naw0A5d5S4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779162539; c=relaxed/simple;
	bh=pgGsa2ISeQZofbueQqfRVtmsrgFY8W3jZQ3Q0WeTOnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9XtnBAS4KbtC4ozriBQ19nwjU5x08UMktaV93n+PRatNzYiumn5W1kt6yC80tUIWiWoMxJPSQNi3vU3X5L6gVn3yxho1VsyBAi4XNOFsc/prUkdbxNQ2+YQ9sQ1PaVm0dVjjSFmp7xY6DTWATcOJ4nzboVmWqyYokFQTaR2RS0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=iF6ecGHM; arc=none smtp.client-ip=115.124.30.112
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="iF6ecGHM"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1779162534; h=From:To:Subject:Date:Message-ID:MIME-Version:Content-Type;
	bh=ZDPgy7Iwyt8ebg5n86XtpUp1Hj+X+MfkDA7W8E465Hs=;
	b=iF6ecGHMVhXKSZKFB113kReStEsRYytCn6Xr64339K/zKsyBN+T5UMX46Xun5G3FdyqgoN88clxnX+RK39zzyz4STbsA6/+Bs04N9cUOk7vNp3Thg3y6X0gftrkZ3eXIbNg6jtQjV/WNTbyyz7O0ZE3WDuzAFiJA2badNqdHGF8=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R451e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam011083073210;MF=cp0613@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0X3EIiWl_1779162529;
Received: from DESKTOP-S9E58SO.localdomain(mailfrom:cp0613@linux.alibaba.com fp:SMTPD_---0X3EIiWl_1779162529 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 19 May 2026 11:48:53 +0800
From: Chen Pei <cp0613@linux.alibaba.com>
To: jic23@kernel.org,
	alison.schofield@intel.com
Cc: dave.jiang@intel.com,
	cp0613@linux.alibaba.com,
	guoren@kernel.org,
	linux-cxl@vger.kernel.org,
	nvdimm@lists.linux.dev
Subject: Re: [ndctl PATCH 2/2] daxctl, util/sysfs: skip module probe-insert when driver is builtin or live
Date: Tue, 19 May 2026 11:48:47 +0800
Message-ID: <20260519034849.38047-1-cp0613@linux.alibaba.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260518170141.215d1755@jic23-huawei>
References: <20260518170141.215d1755@jic23-huawei>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit

On Mon, 18 May 2026 17:01:41 +0100, Jonathan Cameron wrote:

> > I think this patch is worth you trying. In libmkmod code I'm looking at:
> 
> It doesn't work - hence the reply!
> 
> > 
> > https://github.com/lucasdemarchi/kmod/blob/master/libkmod/libkmod-module.c
> > 
> > the "module directory exists but initstate cannot be opened" case returns
> > KMOD_MODULE_BUILTIN, not KMOD_MODULE_COMING.

Hi Jonathan,

Thanks for testing and the detailed analysis.

I wasn't able to reproduce this on my setup because the modules.builtin
index is correctly installed, so kmod_module_get_initstate() returns
KMOD_MODULE_BUILTIN at the first step (via kmod_module_is_builtin())
without ever falling through to the sysfs path.

That said, I understand the scenario — developing in a VM with
CONFIG_DEV_DAX=y but without running modules_install is a perfectly
reasonable workflow, and I agree it's worth addressing.

However, I feel that the suggested workaround (adding a COMING +
sysfs-dir-exists-without-initstate check in ndctl) is papering over
what is fundamentally a libkmod issue. When a module is builtin and
/sys/module/<name>/ exists without an initstate file, libkmod should
not return KMOD_MODULE_COMING — that state implies a module is
actively being loaded, which is not the case for a fully initialized
builtin driver. The root cause is that kmod_module_is_builtin() fails
when modules.builtin is missing, and the sysfs fallback doesn't
distinguish "builtin without initstate" from "module in transition".

I think the proper fix belongs in libkmod: the sysfs fallback in
kmod_module_get_initstate() should return KMOD_MODULE_BUILTIN (or at
least not COMING) when the directory exists but initstate does not.

For now, would it be acceptable to keep this patch as-is (covering the
BUILTIN and LIVE cases) and note in the commit message that the
modules.builtin index must be properly installed for the builtin
detection to work? If there is consensus that ndctl should carry the
workaround regardless, I'm happy to send a v2 with the additional
COMING handling. CC Alison.

Thanks,
Pei
