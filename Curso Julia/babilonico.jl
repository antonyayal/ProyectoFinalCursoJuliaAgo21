{
 "cells": [
  {
   "cell_type": "code",
   "execution_count": 21,
   "id": "811d804e",
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "stdin> 16\n",
      "Metodo Babilonico\n",
      "Introduce el valor de X a calcular:\n",
      "La raiz de 16\n",
      "es:4.0\n"
     ]
    }
   ],
   "source": [
    "#Funcion para leer X\n",
    "function getX()\n",
    "    println(\"Metodo Babilonico\")\n",
    "    println(\"Introduce el valor de X a calcular:\")\n",
    "    l=chomp(readline())\n",
    "    x=parse(Int,l)\n",
    "    return x\n",
    "end\n",
    "#Funcion para calcular raiz de X\n",
    "function raiz(x)\n",
    "    b=x\n",
    "    h=0\n",
    "    while b!=h\n",
    "     b=(b+h)/2\n",
    "     h=x/b\n",
    "    end\n",
    "    return h\n",
    "end\n",
    "    \n",
    "# Ejecutar programa\n",
    "begin   \n",
    "    x=getX()\n",
    "    r=raiz(x)\n",
    "    println(\"La raiz de \", x)\n",
    "    println(\"es:\", r )\n",
    "    \n",
    "end \n",
    "    "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": 19,
   "id": "a00d1646",
   "metadata": {},
   "outputs": [
    {
     "name": "stdout",
     "output_type": "stream",
     "text": [
      "La raiz de \n"
     ]
    }
   ],
   "source": [
    "begin   \n",
    "    #x=getX()\n",
    "    #r=raiz(x)\n",
    "    x=1\n",
    "    r=2\n",
    "    println(\"La raiz de \" )\n",
    "    \n",
    "end "
   ]
  },
  {
   "cell_type": "code",
   "execution_count": null,
   "id": "6db3ca71",
   "metadata": {},
   "outputs": [],
   "source": []
  }
 ],
 "metadata": {
  "kernelspec": {
   "display_name": "Julia 1.6.2",
   "language": "julia",
   "name": "julia-1.6"
  },
  "language_info": {
   "file_extension": ".jl",
   "mimetype": "application/julia",
   "name": "julia",
   "version": "1.6.2"
  }
 },
 "nbformat": 4,
 "nbformat_minor": 5
}
