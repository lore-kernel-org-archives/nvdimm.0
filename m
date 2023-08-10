Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80A821E1C0
	for <nvdimm@lists.linux.dev>; Thu, 10 Aug 2023 17:02:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.us;
 s=s31663417; t=1691686944; x=1692291744; i=fan.ni@gmx.us;
 bh=NTKjMd6cWbRH9lPienkTSSAfXZFsPgC9Ft1FHBVsqE0=;
 h=X-UI-Sender-Class:Date:From:To:Cc:Subject:References:In-Reply-To;
 b=SYU4B7orUAqXEzIIUmRRtzNSYHaqAFAgTCzvJojUqS2CsmedCr8jHlgXxtrl+5B8VKdkKso
 3WCxrvSR0xslfmz6q5lC8jkF0uonrY/iYZqxo2EvLq/FnOCNSvn+khnlC2O9pTnLtFygjaUDU
 Pn2McviDrjh6mLlJIlb+CBcdqhZxWE72t5omDAuPuCDDXtj8+epOZSfjyBnKC9BxSeLizVzQg
 E0UA+zucjDojMTcJXN0N84XxoFlxnpSfzPIU34imTWG4iFrUZVwjNc+8XRboKuNwEr5IH8/6l
 3YXqL8NY88KEEmfCbgxihbj+7FfVOOHQM3MCQeFUcCLoMfg0QgVA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from debian ([99.13.228.231]) by mail.gmx.net (mrgmx104
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1N6sn1-1pjLWa2XV9-018MHQ; Thu, 10
 Aug 2023 19:02:24 +0200
Date: Thu, 10 Aug 2023 10:02:13 -0700
From: Fan Ni <fan.ni@gmx.us>
To: Xiao Yang <yangx.jy@fujitsu.com>
Cc: vishal.l.verma@intel.com, nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org
Subject: Re: [NDCTL PATCH] daxctl: Remove unused mem_zone variable
Message-ID: <ZNUYFSTHC6kEirhm@debian>
References: <20230809154636.11887-1-yangx.jy@fujitsu.com>
Precedence: bulk
X-Mailing-List: nvdimm@lists.linux.dev
List-Id: <nvdimm.lists.linux.dev>
List-Subscribe: <mailto:nvdimm+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:nvdimm+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230809154636.11887-1-yangx.jy@fujitsu.com>
X-Provags-ID: V03:K1:InO/P3hdUC3Y0wt8g+4uYcdhffBO1FkmAl1hpUbN9TCY6PNlaO8
 qvvYxnjZ7jMkXNVC2K53RwGRqTHb+wgTpslBLMWJ9ID5kdkA7qCU1WpZp/CUME0DaO8niD+
 XQrLYhAlrQbQcbEH+kEZQtZzKtzdZeuOH+Otx+Mk6yi+FMCZ6uE+iZL6DVDtSgL+pQwjMmT
 c/KVOZUnn3Ph2uPFU8LMw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Um3mtyNSTyI=;6j1CnMNjGBLImrWhA49zFCaAUg3
 yaduGnaMD9gcaLBIU4vsNNk1YP+V1u6VxzSht1SCU5XUZTFqEueHkSk9Im8fUZogfi6B0D5FD
 Jmu8F8pwB5JTQ0pIL62oF2j8Gy2CA8/8hT00OcN99HjygJq3/N5q5OYIBqCcDQ+Tlol3Ox5UQ
 69ugWmI/dbTW5iLH81kEMgL7qVKu0QH/31acYhVnqVnxwt+OYMB+ruxQ9q5QEVj0CuvJHiSAJ
 CdpCrO1SD7Nsr0yFCM0SslKjKayVG3qi6VEEQ7r/IdW9NZei9NqV1pogHL8QrvvGNghcsMwBL
 B3O4HlP0Crvn74i8jecFrkQhZfkyG1wEqgqa9CAxUNHdc//sZsmc81qxGrZUNNJDurLYHqoMG
 ZKLjyv9cFJe5fRNWVhfGQSda8s7trOH3FT94a6tvHob9ktopjCmHE2DkrRP9oJhO5qwumB8k6
 DpbZT/F5WHd8HiCzr7smXzX0RetuNdEdVKnY74tkJBvhihPCOABYy3rJtRxTfvKwrB45XFu7l
 VpN6RBgZMwy6r/8teW7imT86wwfydknlG6O+S93rT+KG/qDE6rZnhSqyAWmJOEWpNG2YPPYuE
 AMzl1O9zsOdRGJjhodevB+FTnKNC+2WYvKJ4MUp3HUO6Wj0pfR0hZR72YjSwwTXh/WX9FXYpY
 gRGmTAB7Ca5JpMMdk70XRbQ9l+xCuJK/4KWgJJWwRodnmIpH+ffw1EytpvLJydB9FzU5Jxxlb
 yemu7RC25zR4TCzpRESYXaodo9pegagogP3+clBiZDbr0zeQeeOMmi5gH+ntYMAGfGzvJGKu5
 gIOa2TQMUPI+6ivj3TFTMUkVYoB/peYMIycJBy9R8M2Qhr0Ag+rgq3+LZmz3rdvDJBeL3FTeQ
 MAqJeX7OfdJ9I6UfewREuEWZeIWAaLBbZcGq8MxxIb7oK/cOhsl2q9EsamJSoCT76p0rHzsHx
 xO99oMAVBZyBeoKz8LTkQkm0w3o=
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 09, 2023 at 11:46:36PM +0800, Xiao Yang wrote:
> mem_zone variable has never been used so remove it.
>
> Signed-off-by: Xiao Yang <yangx.jy@fujitsu.com>
> ---
>  daxctl/device.c | 6 ------
>  1 file changed, 6 deletions(-)
>
> diff --git a/daxctl/device.c b/daxctl/device.c
> index d2d206b..360ae8b 100644
> --- a/daxctl/device.c
> +++ b/daxctl/device.c
> @@ -59,7 +59,6 @@ enum memory_zone {
>  	MEM_ZONE_MOVABLE,
>  	MEM_ZONE_NORMAL,
>  };

The enum definition is not used also.

Fan

> -static enum memory_zone mem_zone =3D MEM_ZONE_MOVABLE;
>
>  enum device_action {
>  	ACTION_RECONFIG,
> @@ -469,8 +468,6 @@ static const char *parse_device_options(int argc, co=
nst char **argv,
>  				align =3D __parse_size64(param.align, &units);
>  		} else if (strcmp(param.mode, "system-ram") =3D=3D 0) {
>  			reconfig_mode =3D DAXCTL_DEV_MODE_RAM;
> -			if (param.no_movable)
> -				mem_zone =3D MEM_ZONE_NORMAL;
>  		} else if (strcmp(param.mode, "devdax") =3D=3D 0) {
>  			reconfig_mode =3D DAXCTL_DEV_MODE_DEVDAX;
>  			if (param.no_online) {
> @@ -494,9 +491,6 @@ static const char *parse_device_options(int argc, co=
nst char **argv,
>  			align =3D __parse_size64(param.align, &units);
>  		/* fall through */
>  	case ACTION_ONLINE:
> -		if (param.no_movable)
> -			mem_zone =3D MEM_ZONE_NORMAL;
> -		/* fall through */
>  	case ACTION_DESTROY:
>  	case ACTION_OFFLINE:
>  	case ACTION_DISABLE:
> --
> 2.40.1
>
