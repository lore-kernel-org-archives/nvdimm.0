Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620E21D5162
	for <nvdimm@lists.linux.dev>; Mon, 23 Dec 2024 20:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734986461; cv=none; b=UqRLtFlV0I6F34bRbdqHP/U/DCOFFxerMWp38xX/ShotcWC3ndfH+MPNNx+deOXC3KhA9Vah9Gk02boalnZ7URQUmBacm4NXffsX6rw+wxDk6Cf26CPyNX+VCoAlO/TbQ28EUCpNJjQj6iPq+IQcEEjdwIsl+1NE0Qyw1jFSMxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734986461; c=relaxed/simple;
	bh=lhQuTDAwMrcuQ0VuSuwjCJBKNUo6+ySBw73n368V6uQ=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QtZDF68JcriRuLqAsw18qohCQjUpket+qa7GWODnSABsLqCXbZDQBZ3kkTv49AyLNgJ6Fy/6ylDRVqjnnZSZS3bXd+62dKDPeDpgMplshY/tMHmDzxQip1jqtDUKpgO0uetoZ3+wmgVbFVpR6kiwI+TW+rDxL2s8roolaEG16zg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.216])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4YH8yn0rpCz67FbS;
	Tue, 24 Dec 2024 04:39:45 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id 6AA56140A70;
	Tue, 24 Dec 2024 04:40:57 +0800 (CST)
Received: from localhost (10.47.75.118) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 23 Dec
 2024 21:40:55 +0100
Date: Mon, 23 Dec 2024 20:40:54 +0000
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: Zijun Hu <zijun_hu@icloud.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Linus Walleij
	<linus.walleij@linaro.org>, Bartosz Golaszewski <brgl@bgdev.pl>, Uwe
 =?ISO-8859-1?Q?Kleine-K=F6nig?= <ukleinek@kernel.org>, James Bottomley
	<James.Bottomley@HansenPartnership.com>, Thomas =?ISO-8859-1?Q?Wei=DFschu?=
 =?ISO-8859-1?Q?h?= <thomas@t-8ch.de>, <linux-kernel@vger.kernel.org>,
	<nvdimm@lists.linux.dev>, <linux-sound@vger.kernel.org>,
	<sparclinux@vger.kernel.org>, <linux-block@vger.kernel.org>,
	<linux-cxl@vger.kernel.org>, <linux1394-devel@lists.sourceforge.net>,
	<arm-scmi@vger.kernel.org>, <linux-efi@vger.kernel.org>,
	<linux-gpio@vger.kernel.org>, <dri-devel@lists.freedesktop.org>,
	<linux-mediatek@lists.infradead.org>, <linux-hwmon@vger.kernel.org>,
	<linux-media@vger.kernel.org>, <linux-pwm@vger.kernel.org>,
	<linux-remoteproc@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-usb@vger.kernel.org>, <linux-serial@vger.kernel.org>,
	<netdev@vger.kernel.org>, Zijun Hu <quic_zijuhu@quicinc.com>
Subject: Re: [PATCH v4 06/11] driver core: Remove match_any()
Message-ID: <20241223204054.000056db@huawei.com>
In-Reply-To: <20241211-const_dfc_done-v4-6-583cc60329df@quicinc.com>
References: <20241211-const_dfc_done-v4-0-583cc60329df@quicinc.com>
	<20241211-const_dfc_done-v4-6-583cc60329df@quicinc.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: lhrpeml100001.china.huawei.com (7.191.160.183) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Wed, 11 Dec 2024 08:08:08 +0800
Zijun Hu <zijun_hu@icloud.com> wrote:

> From: Zijun Hu <quic_zijuhu@quicinc.com>
> 
> Static match_any() is exactly same as API device_match_any().
is now exactly...

perhaps to call out that it wasn't prior to this set!

> Remove the former and use the later instead.
> 
> Signed-off-by: Zijun Hu <quic_zijuhu@quicinc.com>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> ---
>  drivers/base/core.c | 7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 8116bc8dd6e9eba0653ca686a90c7008de9e2840..289f2dafa8f3831931d0f316d66ee12c2cb8a2e1 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -4114,11 +4114,6 @@ struct device *device_find_child_by_name(struct device *parent,
>  }
>  EXPORT_SYMBOL_GPL(device_find_child_by_name);
>  
> -static int match_any(struct device *dev, const void *unused)
> -{
> -	return 1;
> -}
> -
>  /**
>   * device_find_any_child - device iterator for locating a child device, if any.
>   * @parent: parent struct device
> @@ -4130,7 +4125,7 @@ static int match_any(struct device *dev, const void *unused)
>   */
>  struct device *device_find_any_child(struct device *parent)
>  {
> -	return device_find_child(parent, NULL, match_any);
> +	return device_find_child(parent, NULL, device_match_any);
>  }
>  EXPORT_SYMBOL_GPL(device_find_any_child);
>  
> 

